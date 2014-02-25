/*global
slate: false
*/
'use strict';

slate.bindAll({
	'l:alt' : slate.op('focus', { direction : 'right' }),
	'h:alt' : slate.op('focus', { direction : 'left' }),
	'k:alt' : slate.op('focus', { direction : 'up' }),
	'j:alt' : slate.op('focus', { direction : 'down' }),

	'l:alt,shift' : slate.op('resize', { width : '+10' }),
	'h:alt,shift' : slate.op('resize', { width : '+10', anchor: 'bottom-right' }),
	'k:alt,shift' : slate.op('resize', { height : '+10', anchor: 'bottom-right'}),
	'j:alt,shift' : slate.op('resize', { height : '+10'}),

	'q:alt' : slate.op('hint', { characters : 'asdfghjkl' }),
	'g:alt' : slate.op('grid', {}),
	'a:alt' : slate.op('move', {x : 'screenOriginX', y : 'screenOriginY', width : 'screenSizeX', height : 'screenSizeY' }),
});
