```lua
fn(1, 2, 3) --- all function calls have parens, except the below exceptions
ffi.cdef [[
	void foo();
]]
local x = H.div {
	--
}

-- all declarations are local declarations
-- function a.b and a:b are regular assignments
local a = 1
local b = function () end
object.fn = function () end
class.method = function (self) end

-- when to use assert, when to return `nil, error`?

-- when using ffi:

--- @class module_name_c
--- @field whatever fun(): error_c
-- c errors are typed as `error_c`
-- c structs are typed as `struct_name_c`
-- pointers are typed as `{ [0]: struct_name_c }`
-- arrays are typed as `struct_name_c[]`
	-- do they need `[0]:` as well?
```

- module objects are `mod`
- if there is only one possible return based on the function name, its name is `ret`

<!-- TODO: conventions on iterators vs ??? -->

```lua
--[[@param foo]] --[[@param bar]]
-- NOT
--- @param foo
-- unless required (e.g. generics)
-- same even with --[[@diagnostic]]
```

<!-- TODO: should a.b be extracted into locals -->

- serializers are `source_type_to_dest_type`
- servers are `server`, clients are `client` for now
	- TODO: rename them
- ffi is `ffi_library_name`
	- TODO: rename them

- `@field` format: `<name> <type (no spaces)> <description>`

- string format: `""` in all cases, except:
	- multiline strings
	- DSL strings that tend to require `""`, *especially* if they are often multiline - like HTML
- `i`, `j`, `k` as index variable
- `i = 1, #arr` is ok when performance is an issue but strongly not recommended
- `for _, x in ipairs()` is preferred:
	- perf is probably very similar
	- avoids index variable spam
- *avoid* `local a, b = c, d` - it's hard to read. it should only be for `local a, b = f()`
	- regex: `local .+, .+ =`
	- `local a, b, c, d` is fine (for now) though
		- no need to remove it for the sake of language features because of `local a, b = f()`
- empty lines after functions: **must** be present unless the function is one line
  - comments don't count as empty lines
- one line constructs: only if short enough (line <120 cols, and also still readable)
	- `if`, `for`, `while`, `do`, `repeat`
	- `elseif`
	- `else end`
	- `function end`
	- `()`
- table delimiter: `,`
- table trailing `,`: mandatory if multiline

- regexes to watch out for
	- `'.+'`
	- `[\s;]$`
	- `grep -r 'local [^{]\+, [^{]\+ = [^(]\+$' **/*.lua`
  - `local .+, .+ =`

- transformations:
	- TODO: assignment
	- method to assignment
		- `function (\w+):(\w+)\(`
		- `$1.$2 = function (self, `
	- function to assignment
		- `function ([\w.]+)\(`
		- `$1 = function (`
  - line comment annotations (grep: `[-][-][-] \?@`):
    - `--- @(.+)` -> `--[[@$1]]`

- naming:
  - c types: `type_name_c`
  - ffi bindings (`ffi.C` or `ffi.load()`): `binding_name_ffi`