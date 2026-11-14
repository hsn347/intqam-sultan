local baseComponent = require("fgui.base.baseComponent")
local Com_usm = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_usm", Com_usm)
fgui.register_extension("ui://LoginView/Com_usm", Com_usm)
fgui.register_extension("ui://CommonNew/Com_usmIcon", Com_usm)
function Com_usm:onInit()
	self._loadedEffect = false
	self:setIsUsePaintingMode(false)
end
function Com_usm:onShow()
	if self.getBlendMode and not self.blend1 then
		print("getBlendMode", self.getBlendMode and self:getBlendMode(), self.name)
		self.blendMode = self:getBlendMode()
		local blend = fguiHelper.blendMode2blendFunc(self.blendMode)
		if blend then
			self.blend1, self.blend2 = blend[1], blend[2]
		end
	end
	if self.effectPath then
		print("1111onshow===", self.effectPath)
		self:updateEffect()
		return
	end
	self.loop = self.controllers.c1:getSelectedIndex() == 0
	print("onshow===", self.effectPath)
	self:setEffectPath(self:getCustomData())
end
function Com_usm:onHide()
	if self.ignoreClearEffect then
		return
	end
	self:clearEffect()
	self._loadedEffect = false
end
function Com_usm:play(loop, isStop)
	if loop ~= nil then
		self.loop = loop
	end
	self._loadedEffect = false
	if not self:isVisible() then
		self:setVisible(true)
	elseif self.effect then
		self.effect:stop()
		self.effect:loop(loop)
		self.effect:start()
	end
end
function Com_usm:setVisible(value)
	fgui.GObject.setVisible(self, value)
	if value then
		self:updateEffect(true)
	elseif self.effect then
		self.effect:pause()
	end
end
function Com_usm:setObjVisible(ret)
	fgui.GObject.setVisible(self, ret)
end
function Com_usm:hideEffect()
	self:setObjVisible(false)
	if self.effect then
		self.effect:stop()
	end
end
function Com_usm:showEffect()
	self:setObjVisible(true)
	if self.effect then
		self.effect:stop()
		self.effect:start()
	end
end
function Com_usm:setEffectPath(path, loop, forceSet)
	if loop ~= nil then
		self.loop = loop
	elseif self.loop == nil then
		self.loop = self.controllers.c1:getSelectedIndex() == 0
	end
	if self.effectPath == path and not forceSet then
		return
	end
	self._loadedEffect = false
	self.effectPath = path
	self:updateEffect()
end
function Com_usm:updateEffect(isReplay)
	if not self:isVisible() then
		return
	end
	if self._loadedEffect then
		if self.effect then
			self.effect:pause(false)
		end
		self:updateBlend()
		self:updateFilter()
		return
	end
	self._loadedEffect = true
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty")
		return
	end
	print("create effectPath", self.effectPath)
	if not self.effect then
		if self.fields.icon then
			self.fields.icon:setVisible(true)
			if SoraDIsMemoryLowLevel() and self.fields.icon:getURL() ~= nil then
				print("内存等级低，不加载有默认背景图的usm", self.effectPath)
				return
			end
		end
		self._isLoadComplete = false
		self.effect = nil
		local effect = cc.criSprite.createCriSprite(self.effectPath, false, self.loop, function(crisp)
			if crisp == nil or crisp:getIsError() then
				return
			end
			if self.fields.icon then
				self.fields.icon:stopAllActions()
				self.fields.icon:runAction(ffa.seq(ffa.delay(0.016666666666666666), ffa.callFunc(function()
					self.fields.icon:setVisible(false)
				end)))
			end
			if self._prepareCallback then
				self._prepareCallback(crisp)
			else
				crisp:start()
			end
		end)
		print("usm:", self.effectPath, effect:getContentSize().width, effect:getContentSize().height)
		if self._preViewImage then
			effect:setPreviewImage(self._preViewImage, self._previewSize, self._previewAutoRemove, self._isFadeOut)
		end
		if self.maxChunkSize then
			effect:setMaxChunkSize(self.maxChunkSize)
		end
		self.effect = effect
		self:updateBlend()
		self:updateFilter()
		effect:setCompleteCallback(function()
			self._isLoadComplete = true
			if self._completeCallback then
				self._completeCallback()
			end
		end)
		if self.speedV1 and self.speedV2 then
			self.effect:setSpeed(self.speedV1, self.speedV2)
		end
		self:addChild(self.effect)
		self.effect:Center()
		if self.usmColor then
			self.effect:setColor(self.usmColor)
		end
		if self.usmAP then
			self.effect:setAnchorPoint(self.usmAP)
		end
		if self.usmPos then
			self.effect:setPosition(self.usmPos.x + 25, self.usmPos.y + 25)
		end
		if self.usmScale then
			self.effect:setScale(self.usmScale)
		end
	elseif not isReplay then
		if self.maxChunkSize then
			self.effect:setMaxChunkSize(self.maxChunkSize)
		end
		self.effect:replaceVideoFile(self.effectPath, self.loop)
		if self.speedV1 and self.speedV2 then
			self.effect:setSpeed(self.speedV1, self.speedV2)
		end
		self:updateBlend()
		self:updateFilter()
	else
		self.effect:setSeekPosition(0)
		self.effect:start()
		self:updateBlend()
		self:updateFilter()
	end
end
function Com_usm:setBlendMode(blendMode)
	local blendFunc = fguiHelper.blendMode2blendFunc(blendMode)
	self:setBlendFunc(blendFunc[1], blendFunc[2])
end
function Com_usm:setBlendFunc(blend1, blend2)
	self.blend1, self.blend2 = blend1, blend2
	self:updateBlend()
end
function Com_usm:updateBlend()
	if self.effect and self.blend1 and self.blend2 then
		print("updateBlend===", self.blend1, self.blend2)
		self.effect:setBlendFunc(self.blend1, self.blend2)
	end
end
function Com_usm:updateFilter()
	if self.effect then
		local colorFilter = self:getFilter()
		dump(colorFilter, "colorFilter")
		if colorFilter then
			self.effect:setFilter(colorFilter)
		end
	end
end
function Com_usm:setCompleteCallback(callback)
	self._completeCallback = callback
end
function Com_usm:getCriSprite()
	return self.effect
end
function Com_usm:isLoadComplete()
	return self._isLoadComplete
end
function Com_usm:setPrepareCallback(callback)
	self._prepareCallback = callback
end
function Com_usm:clearEffect()
	if self.effect then
		self.effect:removeFromParent()
		self.effect = nil
	end
	self.effectPath = nil
end
function Com_usm:clearEffectOnly()
	if self.effect then
		self.effect:removeFromParent()
		self.effect = nil
	end
end
function Com_usm:updateUsmColor(color)
	self.usmColor = color
	if self.effect then
		self.effect:setColor(color)
	end
end
function Com_usm:setUsmAP(ap)
	self.usmAP = ap
	if self.effect then
		self.effect:setAnchorPoint(ap)
	end
end
function Com_usm:setUsmPos(pos)
	self.usmPos = pos
	if self.effect then
		self.effect:setPosition(pos.x + 25, pos.y + 25)
	end
end
function Com_usm:setPrivewImage(fileName, size, isAutoRemove, isFadeOut)
	self._prepareCallback = true
	self._preViewImage = fileName
	self._previewSize = size
	self._previewAutoRemove = isAutoRemove
	self._isFadeOut = isFadeOut
end
function Com_usm:setMaxChunkSize(size)
	self.maxChunkSize = size
end
function Com_usm:setUsmScale(scale)
	if self.effect then
		self.effect:setScale(scale)
	end
	self.usmScale = scale
end
function Com_usm:setSpeed(v1, v2)
	self.speedV1 = v1
	self.speedV2 = v2
end
function Com_usm:setUsmColorFilter(brightness, constrast, stauration, hue)
	self:setColorFilter(brightness, constrast, stauration, hue)
	self:updateFilter()
end
function Com_usm:setIgnoreClearEffect(ignore)
	self.ignoreClearEffect = ignore
end
return Com_usm
