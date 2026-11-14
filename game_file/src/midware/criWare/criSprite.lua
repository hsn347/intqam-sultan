local m = fgui.CriSprite
function m:createWithPlayer()
	local ret = fgui.CriSprite()
	ret.isCocos = true
	ret:autoRelease()
	ret.pivotAsAnchor = true
	return ret
end
function m:loop(loop)
	loop = loop or false
	return self:criSpriteLoop(loop)
end
function m:isPlaying()
	return m:isCriSpritePlaying()
end
return m
