// TODO: diffing
function redraw(el/*: HTMLElement*/, old/*: Myow.Data*/, new_/*: Myow.Data*/) {
  // TODO: maybe refactor el out to caller
  while (el.firstChild) { el.removeChild(el.firstChild); }
  const [name, ...things] = new_;
  if (typeof name !== 'string') { throw new Error('Myow.Data must begin with a string, found: ' + JSON.stringify(name)); }
  let child/*: HTMLElement | undefined*/;
  switch (name) {
    case 'spdr:lil:el:text': {
      // FIXME
      child = el.appendChild(document.createElement('p'));
      for (const thing of things) {
        // TODO: events must be handled by us?
        // TODO: no wait, we should return an element or event
      }
      return;
    }
  }
  if (child) {
    el.appendChild(child);
  }
}