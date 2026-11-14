local allianceDesRead = include("allianceDesRead")
local AllianceBuildStateNode = class("allianceBuildStateNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildStateNode")
	end
	return target
end)
function AllianceBuildStateNode:ctor()
	self.tableSpare, _ENV, self.tableSingleData, _ENV = nil, nil, nil, nil
	self.scrollBaseH = 0
	self.scroll = nil
	self.singleIsMoved = false
	self.imgIron = SoraDGetChildByName(self, "Image_iron")
	self.imgIron:getVirtualRenderer():setState(1)
	self.scrollBuild = SoraDGetChildByName(self, "ScrollView_build")
	self.scrollBuild:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollBaseH = self.scrollBuild:getContentSize().height
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.imgMember = SoraDGetChildByName(self, "Image_member")
	self.labelDes:setString(i18n("common_text_3007"))
end
function AllianceBuildStateNode:initData(data)
	self:clearOld()
	for i, v in ipairs(data) do
		_ENV = nil
		;(nil).data = v
		_ENV, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableSingleData, nil)
	end
	self:initScroll()
	self:initMemberList()
end
function AllianceBuildStateNode:clearOld()
	for i, v in ipairs(self.tableSingleData) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingleData, _ENV = ipairs(self.tableSingleData)
end
function AllianceBuildStateNode:initScroll()
	local scrollInner = self.scrollBuild:getInnerContainer()
	local scrollInnerNewH = 100 * #self.tableSingleData
	local scrollW = self.scrollBuild:getContentSize().width
	for i, v in ipairs(self.tableSingleData) do
		v.pos = cc.p(0.5 * scrollW, scrollInnerNewH - (i - 1) * 100 - 10)
		if v.point then
			v.point:setPosition(v.pos)
		end
	end
	self.scrollBuild:setContentSize(cc.size(scrollW, math.min(self.scrollBaseH, scrollInnerNewH)))
	self.scrollBuild:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	self.scrollBuild:setBounceEnabled(scrollInnerNewH > self.scrollBuild:getContentSize().height)
	self.scrollBuild:setSwallowTouches(scrollInnerNewH > self.scrollBuild:getContentSize().height)
	self.scrollBuild:jumpToTop()
end
function AllianceBuildStateNode:scrollEventCallBack(target, event)
	self:initMemberList()
end
function AllianceBuildStateNode:initMemberList()
	local scrollInner = self.scrollBuild:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scrollBuild:getContentSize().height
	_ENV = self.scrollBuild
	self.scrollBuild.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scrollBuild.endY, tableShowH = offsetY + 1.5 * scrollH, self.scrollBuild
	for i, v in ipairs(self.tableSingleData) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = self.imgMember:clone()
				single:addTo(self.scrollBuild)
			end
			local btnPos = SoraDGetChildByName(single, "Button_pos")
			local labelPos = SoraDGetChildByName(single, "Text_pos")
			local labelPro = SoraDGetChildByName(single, "Text_pro")
			local labelName = SoraDGetChildByName(single, "Text_name")
			_ENV = nil
			;(nil).x = v.data.pos.x
			;(nil).y = v.data.pos.y
			labelPos:setString(i18n("common_text_2155", nil))
			SoraDDrawTextUnderLine(labelPos, cc.c4b(0, 60, 85, 255))
			labelName:setString(allianceDesRead.getBuildName(v.data.bid))
			labelPro:setString(i18n("common_text_3006"))
			btnPos:addTouchEventListener(handler(self, self.btnClickCallBack))
			btnPos:setTag(i)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function AllianceBuildStateNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		SoraDGotoWorldMapPoint(self.tableSingleData[tag].data.pos, true)
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function AllianceBuildStateNode:setScroll(scroll)
	self.scroll = scroll
end
return AllianceBuildStateNode
