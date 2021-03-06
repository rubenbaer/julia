## native julia error handling ##

error(e::Exception) = throw(e)
error{E<:Exception}(::Type{E}) = throw(E())
error(s...) = throw(ErrorException(cstring(s...)))

macro unexpected()
    :(error("unexpected branch reached"))
end

## system error handling ##

errno() = ccall(:jl_errno, Int32, ())
strerror(e::Integer) = ccall(:jl_strerror, Any, (Int32,), int32(e))::ByteString
strerror() = strerror(errno())
system_error(p, b::Bool) = b ? error(SystemError(string(p))) : nothing

## assertion functions and macros ##

assert_test(b::Bool) = b
assert_test(b::AbstractArray{Bool}) = all(b)
assert(x) = assert(x,'?')
assert(x,labl) = assert_test(x) ? nothing : error("assertion failed: ", labl)

macro assert(ex)
    :(assert_test($ex) ? nothing : error("assertion failed: ", $string(ex)))
end
