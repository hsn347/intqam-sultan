local AllianceManageView = class("allianceManageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceManageView")
	end
	return target
end)
function AllianceManageView:ctor()
	self.tableSingle, _ENV, self.tableManageData, _ENV = nil, nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_187"))
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_icon")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_CHANGE_FLAG_SUCCESS", handler(self, self.updateFlag))
end
function AllianceManageView:updateFlag()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceDesRead = include("allianceDesRead")
	local curFlag = allianceMgr:getAllianceProperty("flag")
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(curFlag, self.nodeFlag)
end
function AllianceManageView:initData()
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	self.tableManageData = permissionCtrl:getManageMenu()
	self:updateFlag()
	self:initScroll()
end
function AllianceManageView:initScroll()
	for i, v in ipairs(self.tableSingle) do
		v:setVisible(false)
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 155 * math.ceil(#self.tableManageData / 3))
	for i, v in ipairs(self.tableManageData) do
		local posX = SoraDFPosX(520 - (i - 1) % 3 * 200)
		local posY = scrollH - math.floor((i - 1) / 3) * 155
		local single = self.tableSingle[i]
		if single == nil then
			single = SoraDCreatePanel("allianceManageSingle")
			single:addTo(self.scroll)
			table.insert(self.tableSingle, single)
		end
		single:setPosition(posX, posY)
		single:setScroll(self.scroll)
		single:initData(v)
		single:setVisible(true)
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
end
function AllianceManageView:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	end
end
return AllianceManageView
