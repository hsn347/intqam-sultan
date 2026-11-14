local ChangeAllianceRankTitleNode = class("changeAllianceRankTitleNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeAllianceRankTitleNode")
	end
	return target
end)
function ChangeAllianceRankTitleNode:ctor()
	self.tableRankErr, _ENV = nil, nil
	self.btnChange = SoraDGetChildByName(self, "Button_change")
	self.btnChange:setTitleText(i18n("common_text_243"))
	self.labelNew = SoraDGetChildByName(self, "Text_new")
	self.labelNew:setString(i18n("common_text_257"))
	self.labelOld = SoraDGetChildByName(self, "Text_old")
	self.labelOld:setString(i18n("common_text_256"))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_258"))
	self.tableRankTitle = SoraDGetChildsArrayByName(self, "CCS_changeAllianceRankTitleSingle_", 6, 1, true, true)
	self.nodeSize = SoraDGetChildByName(self, "Panel_size")
	self.nodeSize:setSwallowTouches(false)
	self:changeBtnTouch(false)
	if self.btnChange then
		self.btnChange:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self:initData()
end
function ChangeAllianceRankTitleNode:initData()
	for i, v in ipairs(self.tableRankTitle) do
		v:initData(i)
		v:setHandle(handler(self, self.updateBtnType))
		table.insert(self.tableRankErr, true)
	end
end
function ChangeAllianceRankTitleNode:updateBtnType(rankID, isCanTouch)
	self.tableRankErr[rankID] = isCanTouch
	for i, v in ipairs(self.tableRankErr) do
		if v == false then
			self:changeBtnTouch(false)
			return
		end
	end
	self:changeBtnTouch(true)
end
function ChangeAllianceRankTitleNode:changeBtnTouch(isCanTouch)
	self.btnChange:setTouchEnabled(isCanTouch)
	self.btnChange:setBright(isCanTouch)
end
function ChangeAllianceRankTitleNode:getSingleH()
	return self.nodeSize:getContentSize().height
end
function ChangeAllianceRankTitleNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceSetting = gametop.playertop_:getModule("allianceSetting")
		local _ENV, rankNameList = gametop.playertop_, gametop.playertop_
		for i, v in ipairs(self.tableRankTitle) do
			local newTitle = v:getRankTitle()
			if newTitle then
				rankNameList["r" .. i .. "Name"] = newTitle
			end
		end
		allianceSetting:reqModifyRankName(rankNameList)
		self:changeBtnTouch(false)
	end
end
return ChangeAllianceRankTitleNode
