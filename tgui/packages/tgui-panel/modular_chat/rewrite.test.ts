import { describe, expect, it } from 'bun:test';

import { rewriteModularChatComponents } from './rewrite';

function build(html: string): HTMLElement {
  const node = document.createElement('div');
  node.innerHTML = html;
  return node;
}

const TIP = 'A holy relic.<br>It burns the unworthy.';

describe('rewriteModularChatComponents', () => {
  it('renames the unknown component to one the renderer registers', () => {
    const node = build(
      `<span data-component="TooltipHTML" data-html="${TIP}" class="tooltip">a sword</span>`,
    );

    rewriteModularChatComponents(node);

    const span = node.querySelector('span')!;
    expect(span.getAttribute('data-component')).toBe('Tooltip');
    expect(span.textContent).toBe('a sword');
  });

  it('flattens the tip to text, keeping the line break as a separator', () => {
    const node = build(
      `<span data-component="TooltipHTML" data-html="${TIP}">a sword</span>`,
    );

    rewriteModularChatComponents(node);

    const span = node.querySelector('span')!;
    expect(span.getAttribute('data-content')).toBe(
      'A holy relic. — It burns the unworthy.',
    );
    expect(span.getAttribute('data-html')).toBeNull();
  });

  it('drops the component when there is no tip to show', () => {
    const node = build('<span data-component="TooltipHTML">a sword</span>');

    rewriteModularChatComponents(node);

    const span = node.querySelector('span')!;
    expect(span.hasAttribute('data-component')).toBe(false);
    expect(span.textContent).toBe('a sword');
  });

  it('leaves components the renderer already knows alone', () => {
    const node = build(
      '<span data-component="Tooltip" data-content="plain">a sword</span>',
    );

    rewriteModularChatComponents(node);

    const span = node.querySelector('span')!;
    expect(span.getAttribute('data-component')).toBe('Tooltip');
    expect(span.getAttribute('data-content')).toBe('plain');
  });

  it('is idempotent, because translateNode recurses over the same subtree', () => {
    const node = build(
      `<span data-component="TooltipHTML" data-html="${TIP}">a sword</span>`,
    );

    rewriteModularChatComponents(node);
    const once = node.innerHTML;
    rewriteModularChatComponents(node);

    expect(node.innerHTML).toBe(once);
  });

  it('ignores nodes that cannot be queried, such as text nodes', () => {
    const text = document.createTextNode('a sword');

    expect(() => rewriteModularChatComponents(text)).not.toThrow();
  });

  it('rewrites every occurrence in one message', () => {
    const node = build(
      `<span data-component="TooltipHTML" data-html="one">a</span>` +
        `<span data-component="TooltipHTML" data-html="two">b</span>`,
    );

    rewriteModularChatComponents(node);

    const spans = node.querySelectorAll('[data-component]');
    expect(spans.length).toBe(2);
    expect(spans[0].getAttribute('data-content')).toBe('one');
    expect(spans[1].getAttribute('data-content')).toBe('two');
  });
});
