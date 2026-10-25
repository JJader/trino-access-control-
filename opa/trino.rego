package trino

import rego.v1

# Permite operações por padrão.
default allow := true

# Mascara com NULL colunas cujo nome começa com "mask",
# sem diferenciar maiúsculas de minúsculas:
# mask, mask_number, mask_xxx, mask_HOME, etc.
columnMask := {
    "expression": sprintf(
        "to_hex(sha256(to_utf8(CAST(\"%s\" AS VARCHAR))))",
        [replace(column.columnName, "\"", "\"\"")]
    )
} if {
    input.context.identity.user == "blocked_user"
    column := input.action.resource.column
    regex.match("(?i)^mask.*", column.columnName)
}
