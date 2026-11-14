local worldLodDef = worldMapDefine.worldLodDef
local commonLODInstance = class("commonLODInstance", function(target)
	if not target._setVisible then
		target._setVisible = target.setVisible
	end
	return target
end)
function commonLODInstance:ctor()
	self.baseVisible = self:isVisible()
	self.lodVisible = true
	self.showPos = cc.p(self:getPositionX(), self:getPositionY())
end
function commonLODInstance:setVisible(visible)
	self.baseVisible = visible
	self:updateVisible()
end
function commonLODInstance:updateMapLod(event)
	local lod = event.lod
	local preVisible = self.lodVisible
	self.lodVisible = lod <= self.showLodMax and lod >= self.showLodMin
	if preVisible == self.lodVisible then
		return
	end
	if self.lodVisible then
		if self.hidePos then
			self:setPosition(self.hidePos)
			self:showFunc()
			return
		end
	elseif self.hidePos then
		self:hideFunc()
		return
	end
	self:updateVisible()
end
function commonLODInstance:initMapLod(lod)
	self.lodVisible = lod <= self.showLodMax and lod >= self.showLodMin
	if self.hidePos then
		self:setPosition(self.showPos)
	end
	if self.beforeShow then
		self.beforeShow()
	end
	self:updateVisible()
end
function commonLODInstance:updateVisible(...)
	self:_setVisible(self.baseVisible and self.lodVisible)
end
function commonLODInstance:initLODData(data)
	self.showLodMin = data.showLodMin or worldLodDef.LOD1
	self.showLodMax = data.showLodMax or worldLodDef.LOD6
	if data.offset then
		self.hidePos = cc.p(self.showPos.x + data.offset.x, self.showPos.y + data.offset.y)
	end
	self.time = data.time or 0.5
	self.beforeShow = data.beforeShow
	self.afterHide = data.afterHide
	self.isFgui = data.isFgui or self.isFgui
end
function commonLODInstance:showFunc(...)
	if self.hideAct then
		self:stopAction(self.hideAct)
		self.hideAct = nil
	end
	self:updateVisible()
	if self.beforeShow then
		self.beforeShow()
	end
	if self.isFgui then
		_UPVALUE1_ = self
		self[1] = ffa.moveTo(self.time, self.showPos)
		self[2] = ffa.callFunc(function()
			self.showAct = nil
		end)
		self[3] = ffa.callFunc(function()
			self.showAct = nil
		end)
		self.showAct = ffa.seq(self)
		self:runAction(self.showAct)
	else
		_ENV = self.time
		self.time.easing = "backout"
		function self.time.onComplete()
			self.showAct = nil
		end
		self.showAct = transition.execute(self, cca.moveTo(self.time, self.showPos), self.time)
	end
end
function commonLODInstance:hideFunc(...)
	if self.showAct then
		self:stopAction(self.showAct)
		self.showAct = nil
	end
	if self.isFgui then
		_UPVALUE1_ = self
		self[1] = ffa.moveTo(self.time, self.hidePos)
		self[2] = ffa.callFunc(function()
			self.hideAct = nil
			self:updateVisible()
			if self.afterHide then
				self.afterHide()
			end
		end)
		self[3] = ffa.callFunc(function()
			self.hideAct = nil
			self:updateVisible()
			if self.afterHide then
				self.afterHide()
			end
		end)
		self.hideAct = ffa.seq(self)
		self:runAction(self.hideAct)
	else
		_ENV = self.time
		self.time.easing = "backin"
		function self.time.onComplete()
			self.hideAct = nil
			self:updateVisible()
			if self.afterHide then
				self.afterHide()
			end
		end
		self.hideAct = transition.execute(self, cca.moveTo(self.time, self.hidePos), self.time)
	end
end
return commonLODInstance
