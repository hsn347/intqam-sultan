local petraRareTreasureMainSingle = class("petraRareTreasureMainSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("petraRareTreasureMainSingle")
	end
	if target ~= nil then
		local timerClass = include("commonItemAward")
		target = timerClass.new(target)
	end
	return target
end)
local petraRareTreasureDef = include("petraRareTreasureDef")
function petraRareTreasureMainSingle:ctor()
end
function petraRareTreasureMainSingle:initItemData(index, data, view)
	self.index = index
	self.tableData = data
	if self.index == petraRareTreasureDef.BEST_TREASURE then
		self:initItemData_Best(data, view)
		self:setCliperNode()
	elseif self.index == petraRareTreasureDef.LUCKY_KEY then
		self:setOwnView(view)
		self:initData(self.tableData.id)
	else
		self:setOwnView(view)
		self:initData(self.tableData.id, self.tableData.count)
		self.Image_icon:setScale(0.5)
		self:setCliperNode(37)
	end
end
function petraRareTreasureMainSingle:setCliperNode(num)
	if not self.cliperNode then
		local img, cliperNode = SoraDClipCircleImg(self.Image_quality, num)
		self.Image_quality = img
		cliperNode:setLocalZOrder(1)
		self.cliperNode = cliperNode
		local spIcon = SoraDGetChildByName(self, "Image_quality_fg")
		if spIcon then
			spIcon:setScale(0.74)
			spIcon:setLocalZOrder(2)
		end
	end
end
function petraRareTreasureMainSingle:initItemData_Best(data, view)
	local enable = data ~= nil
	do
		local spIcon = SoraDGetChildByName(self, "Image_numBg")
		if spIcon then
			spIcon:setVisible(enable)
		end
	end
	do
		local spIcon = SoraDGetChildByName(self, "Sprite_Icon")
		if spIcon then
			spIcon:setVisible(not enable)
		end
	end
	do
		local nodeBg = SoraDGetChildByName(self, "Node_quality_bg")
		if nodeBg then
			nodeBg:setVisible(enable)
		end
	end
	self.Image_icon:setVisible(enable)
	self:setTouchEnabled(enable)
	if data then
		self:setOwnView(view)
		self:initData(self.tableData.id, self.tableData.count)
	else
		self:hideNum()
	end
end
function petraRareTreasureMainSingle:initCircusBigRunCount(data)
	local label = ccui.Text:create()
	label:addTo(self, 1)
	label:setString(string.format("x%d", data.count))
	label:setFontSize(18)
	label:setPosition(0, -22)
end
function petraRareTreasureMainSingle:showCoolSquare(...)
	if not self.coolSquare then
		local effect = SoraDCreatAnimation("Node_Effect_jnh02")
		SoraDMixtureGLONEByParent(effect)
		effect:addTo(self, 2)
		effect:setScale(0.8)
		self.coolSquare = effect
		self.Effect_Once = SoraDGetChildByName(effect, "Effect_Once")
		self.Effect_Once:setVisible(false)
	else
		self.coolSquare:setVisible(true)
	end
end
function petraRareTreasureMainSingle:showEffectOnce(...)
	self.Effect_Once:setVisible(true)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.75)
	;(nil)[2] = cca.callFunc(function()
		self.Effect_Once:setVisible(false)
	end)
	;(nil)[3] = cca.callFunc(function()
		self.Effect_Once:setVisible(false)
	end)
	self:runAction(cca.seq(nil))
end
return petraRareTreasureMainSingle
