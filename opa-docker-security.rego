
package main

secrets_env := [
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

deny[msg] {
    some i
    input[i].Cmd == "env"
    val := input[i].Value
    some j
    contains(lower(val[j]), secrets_env[_])
    msg := sprintf("Line %d: Potential secret in ENV key found: %s", [i, val])
}

deny[msg] {
    some i
    input[i].Cmd == "from"
    val := split(input[i].Value[0], ":")
    count(val) > 1
    contains(lower(val[1]), "latest")
    msg := sprintf("Line %d: do not use 'latest' tag for base images", [i])
}

deny[msg] {
    some i
    input[i].Cmd == "run"
    val := concat(" ", input[i].Value)
    matches := regex.find_n("(curl|wget)[^|^>]*[|>]", lower(val), -1)
    count(matches) > 0
    msg := sprintf("Line %d: Avoid curl bashing", [i])
}

warn[msg] {
    some i
    input[i].Cmd == "run"
    val := concat(" ", input[i].Value)
    regex.match(".*?(apk|yum|dnf|apt|pip).+?(install|dist-upgrade|upgrade|update).*", lower(val))
    msg := sprintf("Line %d: Do not upgrade your system packages: %s", [i, val])
}

deny[msg] {
    some i
    input[i].Cmd == "add"
    msg := sprintf("Line %d: Use COPY instead of ADD", [i])
}

any_user {
    some i
    input[i].Cmd == "user"
}

deny[msg] {
    not any_user
    msg := "Do not run as root, use USER instead"
}

forbidden_users := [
    "root",
    "toor",
    "0"
]

deny[msg] {
    command := "user"
    users := [name | some i; input[i].Cmd == "user"; name := input[i].Value]
    lastuser := users[count(users) - 1]
    contains(lower(lastuser), forbidden_users[_])
    msg := sprintf("Line %d: Last USER directive (USER %s) is forbidden", [i, lastuser])
}

deny[msg] {
    some i
    input[i].Cmd == "run"
    val := concat(" ", input[i].Value)
    contains(lower(val), "sudo")
    msg := sprintf("Line %d: Do not use 'sudo' command", [i])
}

multi_stage := true {
    some i
    input[i].Cmd == "copy"
    val := concat(" ", input[i].Flags)
    contains(lower(val), "--from=")
}

deny[msg] {
    not multi_stage
    msg := "You COPY, but do not appear to use multi-stage builds..."
}
