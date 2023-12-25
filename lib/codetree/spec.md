# codetree

a language-agnostic code tree

## format

all interfaces should be valid json.  
base interface:

```ts
interface Node<Type extends string> {
	type: Type;
}
```

<!-- TODO: void? null? unndefined? there should be some way to represent both null and undefined in JS -->

### boolean

```ts
interface BooleanNode extends Node<"boolean"> {
	type: "boolean";
	value: boolean;
}
```

### integer

not required to be exactly representable by a 64-bit ieee754 float

```ts
interface NumberNode extends Node<"integer"> {
	type: "integer";
	value: number;
}
```

### number

not required to be exactly representable by a 64-bit ieee754 float

```ts
interface NumberNode extends Node<"number"> {
	type: "string";
	value: number;
}
```

### string

```ts
interface StringNode extends Node<"string"> {
	type: "string";
	value: string;
}
```

### array

```ts
interface ArrayNode extends Node<"array"> {
	type: "array";
	values: Node[];
}
```

### struct

<!-- FIXME: what should be done in languages that do not support arbitrary keys?
JS has `Map`... but i don't think that is idiomatic -->

```ts
interface StructNode extends Node<"struct"> {
	type: "struct";
	entries: StructEntry[];
}

interface StructEntry {
	key: Node;
	value: Node;
}
```

### block

a block expression.

<!-- TODO: how to match semantics between block-as-expression and block-as-statement -->
<!-- it's possible to require a `VoidNode` as the last statement, but then the issue is ensuring that `VoidNode`s do not appear in unexpected places. -->

```ts
interface BlockNode extends Node<"block"> {
	type: "block";
	statements: Node[];
}
```

### function

a function _expression_, not a function statement.  
a body containing multiple statements should be a [`BlockNode`](#block).  
a named function should be a [`FunctionNode`](#function) inside a [`DeclarationNode`](#declaration).

```ts
interface FunctionNode extends Node<"function"> {
	type: "function";
	parameters: Node[];
	body: Node;
}
```

### call

used for:

- normal function calls
- operator applications (which should typically use an `ident` node with a standard name, like `add` for `+`, although using `+` as the ident is not explicitly disallowed)

```ts
interface CallNode extends Node<"call"> {
	type: "call";
	function: Node;
	arguments: Node[];
}
```

### declaration

a statement that defines a new local variable

```ts
interface DeclarationNode extends Node<"declaration"> {
	type: "declaration";
	name: string;
	value: Node;
}
```

### if

<!-- TODO: if, for, while, do, repeat, match, loop, cond, etc. -->
<!-- which are the most general? what is the most useful structure? -->
<!-- is if just a specialization of cond? similarly with while and for vs loop? -->

```ts
interface IfNode extends Node<"if"> {
	type: "if";
	then: Node;
	else: Node;
}
```
