local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local worldMapAtlantisSkill = class("worldMapAtlantisSkill", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisSkill")
	end
	return target
end)
function worldMapAtlantisSkill:ctor(target, warType)
	self.isShow = true
	self.tableSingle, _ENV, self.warType = warType or gKingdomClassType.atlantis, warType or gKingdomClassType.atlantis, warType or gKingdomClassType.atlantis
	self:updateSkillData()
	self:initWidget()
end
function worldMapAtlantisSkill:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_skill:addTouchEventListener(handler(self, self.openSkillView))
	self.scroll = self.ScrollView_skill
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
end
function worldMapAtlantisSkill:initData(...)
	self:updateSkillData()
	self.buffIdList, atlantisWarCtrl, self.buffList = atlantisWarCtrl:getPlayerBuffList(), atlantisWarCtrl:getPlayerBuffList(), atlantisWarCtrl:getPlayerBuffList()
	for k, v in pairs(self.buffList) do
		if ATLANTIS_WAR_BOSS_ACTIVE_BUFF[v.effect] then
			table.insert(self.buffIdList, v.id)
		end
	end
	table.sort(self.buffIdList, function(a, b)
		local atime = self.buffList[tostring(a)].beginTime
		local btime = self.buffList[tostring(b)].beginTime
		if atime ~= btime then
			return atime > btime
		end
		return b < a
	end)
	self:refreshScrollSize()
	local count = 5 + #self.buffIdList
	local itemW = 95
	local scrollW = self.scroll:getInnerContainerSize().width
	self.scroll:removeAllChildren()
	self.tableSingle, atlantisWarCtrl = self.scroll.removeAllChildren, self.scroll.removeAllChildren
	for i = 1, count do
		local skill = SoraDCreatePanel("worldMapAtlantisSkillSingle")
		skill:addTo(self.scroll)
		local pos = cc.p(SoraDFPosX(scrollW - itemW * i, scrollW), 50)
		skill:setPosition(pos)
		skill:setWarType(self.warType)
		local sIndex = i - (count - 5)
		atlantisWarCtrl = skill
		local skill.scroll, otherData = self.scroll, skill
		local atlantisWarCtrl, data = self.scroll, self.scroll
		if 0 < sIndex then
			atlantisWarCtrl = nil
			;(nil).index = sIndex
			;(nil).isPrivilegeLock = self.isPrivilegeLock
			;(nil).skillSlot = self.skillSlot[tostring(sIndex)]
			skill:initOutWarData(nil, otherData)
		else
			atlantisWarCtrl = nil
			;(nil).buffData = self.buffList[tostring(self.buffIdList[i])]
			skill:initInWarData(nil, otherData)
		end
		atlantisWarCtrl = skill
		skill.point = skill
		self.tableSingle[i], skill.pos = skill, pos
	end
	self:jumpTpFirst()
end
function worldMapAtlantisSkill:refreshScrollSize(...)
	local count = 5 + #self.buffIdList
	local itemW = 95
	local sSize = self.scroll:getContentSize()
	local totalW = itemW * (count + 0.5)
	local scrollW = math.max(totalW, sSize.width)
	self.scroll:setInnerContainerSize(cc.size(scrollW, sSize.height))
end
function worldMapAtlantisSkill:setStateShow(isShow)
	self.isShow = isShow
	self.Button_skill:setVisible(self.isShow)
	self.scroll:setVisible(self.isShow)
	self.Node_line:setVisible(self.isShow)
	local iSize = self.Image_bg:getContentSize()
	local iWidth = self.isShow and 470 or 67
	self.Image_bg:setContentSize(cc.size(iWidth, iSize.height))
end
function worldMapAtlantisSkill:openSkillView(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.warType == gKingdomClassType.roaringFlame then
			uiManager:show("RoaringFlame_Skill")
		else
			SoraDCreatePanel("atlantisSkillView"):show()
		end
	end
end
function worldMapAtlantisSkill:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:refreshScroll()
	end
end
function worldMapAtlantisSkill:refreshScroll(...)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetX = -scrollInner:getPositionX()
	local scrollW = self.scroll:getContentSize().width
	local itemW = 88
	local halfW = itemW * 0.5
	_ENV = nil
	;(nil).beginX = offsetX - halfW
	local (nil).endX, tableShowW = offsetX + halfW, nil
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.pos.x > tableShowW.beginX and v.pos.x < tableShowW.endX then
				local scale = math.abs(v.pos.x - (tableShowW.beginX + halfW)) / halfW
				local s = 0.89
				scale = math.min(1, s + scale * (1.0 - s))
				v.point:setScale(scale)
			else
				v.point:setScale(1)
			end
		end
	end
end
function worldMapAtlantisSkill:refreshOutWarSingle(index)
	self:updateSkillData()
	local tIndex = index + #self.buffIdList
	local single = self.tableSingle[tIndex]
	local point = single and single.point
	if point then
		_ENV = nil
		;(nil).index = index
		;(nil).isPrivilegeLock = self.isPrivilegeLock
		;(nil).skillSlot = self.skillSlot[tostring(index)]
		point:initOutWarData(nil)
	end
end
function worldMapAtlantisSkill:refreshInWarSingle(buffId)
	self.buffList = atlantisWarCtrl:getPlayerBuffList()
	local index = table.indexof(self.buffIdList, buffId)
	local single = self.tableSingle[index]
	local point = single and single.point
	if point then
		atlantisWarCtrl = nil
		;(nil).index = index
		;(nil).buffData = self.buffList[tostring(buffId)]
		point:initInWarData(nil)
	end
end
function worldMapAtlantisSkill:addInWarSingle(buffId)
	self.buffList = atlantisWarCtrl:getPlayerBuffList()
	table.insert(self.buffIdList, 1, buffId)
	local skill = SoraDCreatePanel("worldMapAtlantisSkillSingle")
	skill:addTo(self.scroll)
	atlantisWarCtrl = skill.addTo
	local skill.addTo.scroll, otherData = self.scroll, skill.addTo
	atlantisWarCtrl = nil
	;(nil).buffData = self.buffList[tostring(buffId)]
	skill:initInWarData(nil, otherData)
	atlantisWarCtrl = otherData
	otherData.point = skill
	otherData.pos = cc.p(0, 0)
	table.insert(self.tableSingle, 1, otherData)
	self:refreshScrollSize()
	local itemW = 95
	local scrollW = self.scroll:getInnerContainerSize().width
	for i, v in ipairs(self.tableSingle) do
		v.pos = cc.p(SoraDFPosX(scrollW - itemW * i, scrollW), 50)
		v.point:setPosition(v.pos)
	end
	self:jumpTpFirst()
end
function worldMapAtlantisSkill:removeInWarSingle(buffId)
	local index = table.indexof(self.buffIdList, buffId)
	table.remove(self.buffIdList, index)
	local single = self.tableSingle[index]
	local point = single and single.point
	if point then
		point:removeFromParent()
		table.remove(self.tableSingle, index)
	end
	self:refreshScrollSize()
	local itemW = 95
	local scrollW = self.scroll:getInnerContainerSize().width
	for i, v in ipairs(self.tableSingle) do
		v.pos = cc.p(SoraDFPosX(scrollW - itemW * i, scrollW), 50)
		v.point:setPosition(v.pos)
	end
	self:jumpTpFirst()
end
function worldMapAtlantisSkill:jumpTpFirst(...)
	if SoraDFIsRA() then
		self.scroll:jumpToRight()
	else
		self.scroll:jumpToLeft()
	end
end
function worldMapAtlantisSkill:updateSkillData(...)
	if self.warType == gKingdomClassType.roaringFlame then
		self.skillSlot = roaringFlameWarCtrl:getSkillSlot()
		self.isPrivilegeLock = roaringFlameWarCtrl:getIsPrivilegeLock()
	else
		self.skillSlot = atlantisActivityCtrl:getSkillData("skillSlot")
		self.isPrivilegeLock = atlantisActivityCtrl:getSkillData("isPrivilegeLock")
	end
end
return worldMapAtlantisSkill
