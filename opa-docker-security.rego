
# Do Not store secrets in ENV variables
secrets_env = [
    "passwd",
    "password",
    "pass",
    "secret",
    "key",
    "access",
    "api_key",
    "apikey",
    "token",
    "tkn"
]

deny[msg] if {    
    input[i].Cmd == "env"
    val := input[i].Value
    contains(lower(val[_]), secrets_env[_])
    msg = sprintf("Line %d: Potential secret in ENV key found: %s", [i, val])
}

# Only use trusted base images
#deny[msg] if {
#    input[i].Cmd == "from"
#   val := split(input[i].Value[0], "/")
#    count(val) > 1
#    msg = sprintf("Line %d: use a trusted base image", [i])
#}