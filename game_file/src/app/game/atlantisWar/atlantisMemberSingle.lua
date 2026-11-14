local gametop = gModuleMgr.getObject("gametop")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local lordLocalData = include("lordLocalData")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local atlantisMemberSingle = class("atlantisMemberSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisMemberSingle")
	end
	return target
end)
function atlantisMemberSingle:ctor()
	self.showOnline = true
	self:initWidget()
end
function atlantisMemberSingle:setShowOnline(isShow)
	self.showOnline = isShow
end
function atlantisMemberSingle:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_powerLab:setString(i18n("common_text_090"))
	self.Text_online:setString(i18n("common_text_224"))
	self.ccs_lv = SoraDGetExtendChildFromCCSByName(self, "CCS_commonCastleLvStarLv_1")
	self.Panel_touch:setSwallowTouches(false)
	self.Panel_touch = SoraDCreatePanelByCloneNode(self.Panel_touch, "commonBtnInstance")
	self.Panel_touch:setHandle(handler(self, self.btnPanelClick))
end
function atlantisMemberSingle:initData(data, otherData)
	self.tableSingleData = data
	local isOnline = data.online == 0
	self.scroll = otherData.scroll
	self.viewType = otherData.viewType
	if data.online ~= nil then
		self.Panel_touch:setTouchEnabled(true)
		self.Text_powerLab:setVisible(true)
		self.ccs_lv:setVisible(true)
		self.Image_portrait:loadTexture(lordLocalData.getBust(data.headid), ccui.TextureResType.plistType)
		if isOnline or not self.showOnline then
			self.Text_power:setColor(cc.c3b(247, 216, 71))
		else
			self.Text_power:setColor(cc.c3b(145, 145, 145))
			self.Text_lastTime:setString(SoraDConverSecondToDate(data.online, false, true))
		end
		self.Text_power:setString(string.formatnumberthousands(data.totalFc))
		if self.showOnline then
			self.Text_online:setVisible(isOnline)
			self.Text_lastTime:setVisible(not isOnline)
		else
			self.Text_online:setVisible(false)
			self.Text_lastTime:setVisible(false)
		end
		self.Text_name:setString(data.nickName)
		self.ccs_lv:initData(data.cityLevel, data.starLv)
		self.Panel_touch:setScroll(self.scroll)
	else
		self.Panel_touch:setTouchEnabled(false)
		self.Text_powerLab:setVisible(false)
		self.ccs_lv:setVisible(false)
		self.Text_online:setString(i18n("common_text_480"))
		self.Image_portrait:loadTexture(lordLocalData.getBust(data.headid), ccui.TextureResType.plistType)
	end
end
function atlantisMemberSingle:btnPanelClick(button, eventType)
	if self.viewType == "atlantisManagerSingle" then
		local playerID = self.tableSingleData.uid
		local kid = gametop.playertop_:getKingdomID()
		gametop = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		return
	end
	local panel = SoraDCreatePanel("atlantisMemberSetting")
	panel:initData(self.tableSingleData)
	panel:show()
end
return atlantisMemberSingle
