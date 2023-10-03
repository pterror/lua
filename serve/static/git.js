/** @typedef {
| { type: "branch"; name: string; branch: string; }
| { type: "remote_branch"; name: string; remote: string; branch: string }
| { type: "remote"; name: string; remote: string; }
| { type: "tag"; name: string; tag: string; }
| { type: "notes"; name: string; namespace: string; }
| { type: "commit"; name: string; commit: string; }
} Ref */
/** @type {(ref: string) => Ref} */
export const parseRef = (ref) => {
	let match = ref.match(/^refs\/heads\/(.+)$/);
	if (match) return { type: "branch", name: match[1], branch: match[1] };
	match = ref.match(/^refs\/remotes\/(.+?)\/(.+)$/);
	if (match)
		return {
			type: "remote_branch",
			name: `${match[1]}/${match[2]}`,
			remote: match[1],
			branch: match[2],
		};
	match = ref.match(/^refs\/remotes\/(.+)$/);
	if (match) return { type: "remote", name: match[1], remote: match[1] };
	// TODO: this is never true because checking out a tag goes to its commit.
	match = ref.match(/^refs\/tags\/(.+)$/);
	if (match) return { type: "tag", name: match[1], tag: match[1] };
	match = ref.match(/^refs\/notes\/(.+)$/);
	if (match) return { type: "notes", name: match[1], namespace: match[1] };
	// TODO: "ref" may be "HEAD"
	return { type: "commit", name: ref, commit: ref };
};
