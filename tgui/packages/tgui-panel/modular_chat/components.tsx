/**
 * @file
 * Fork-owned chat-embedded components.
 *
 * Chat-embedded components are a two-sided protocol: DM emits
 * `<span data-component="Name" data-prop="...">`, and the renderer only
 * instantiates names present in `TGUI_CHAT_COMPONENTS`, passing only attributes
 * present in `TGUI_CHAT_ATTRIBUTES_TO_PROPS`. Anything this fork's DM emits that
 * upstream's renderer does not know about belongs here, so that
 * `chat/renderer.tsx` carries one import and two spreads and nothing else.
 *
 * See modular_abel/UPSTREAM_FIXES.md.
 */

import type { ComponentProps, ReactNode } from 'react';
import { Tooltip } from 'tgui-core/components';

/**
 * Attribute values arrive as strings (or coerced numbers/booleans) from the DOM,
 * so `position` is taken straight from whatever `Tooltip` currently accepts
 * rather than restated here — a tgui-core bump changing that list should fail
 * the typecheck, not silently pass an invalid placement.
 */
type TooltipHTMLProps = {
  html?: string | number | boolean;
  position?: ComponentProps<typeof Tooltip>['position'];
  children?: ReactNode;
};

/**
 * `span_tooltip_dangerous_html()` (code/__DEFINES/chat/span.dm) carries its tip
 * as an HTML string in `data-html`, which `Tooltip` cannot take directly — its
 * `content` is a ReactNode, not markup.
 */
function TooltipHTML(props: TooltipHTMLProps) {
  const { html, position, children } = props;

  return (
    <Tooltip
      position={position}
      content={
        <span dangerouslySetInnerHTML={{ __html: String(html ?? '') }} />
      }
    >
      {children}
    </Tooltip>
  );
}

/** Merged into `TGUI_CHAT_COMPONENTS`. */
export const MODULAR_CHAT_COMPONENTS = {
  TooltipHTML,
};

/**
 * Merged into `TGUI_CHAT_ATTRIBUTES_TO_PROPS`. HTML attribute names are
 * lowercase-only, which is why the map exists at all.
 */
export const MODULAR_CHAT_ATTRIBUTES_TO_PROPS = {
  html: 'html',
};
