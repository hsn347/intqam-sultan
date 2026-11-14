_ENV = nil
;(nil).NAME = 1
;(nil).UID = 2
local (nil).ALLIANCE, SORT_TYPE = 3, nil
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingPacksRead = include("kingPacksRead")
local WorldMapKingdomCityAppointSelect = class("worldMapKingdomCityAppointSelect", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityAppointSelect")
	elseif type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function WorldMapKingdomCityAppointSelect:ctor()
	self.tableSpare, SORT_TYPE, self.memberListData, SORT_TYPE, self.limitList, SORT_TYPE = nil, nil, nil, nil, nil, nil
	self.fromLoadText = false
	self.keyName = ""
	self.nextIndex = nil
	self.searchMode = nil
	self.isHaveTextField = true
	self.showAlliance = false
	self.curSortType = SORT_TYPE.NAME
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNone = SoraDGetChildByName(self, "Text_none")
	self.labelNone:setString(i18n("common_text_963"))
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_invite")
	self.Node_chooseList = SoraDGetChildByName(self, "Node_chooseList")
	self.Text_choose = SoraDGetChildByName(self.Node_chooseList, "Text_choose")
	self.Image_border = SoraDGetChildByName(self.Node_chooseList, "Image_border")
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.Button_choose:setTitleText(i18n("common_text_3155"))
	self.Button_name = SoraDGetChildByName(self, "Button_name")
	self.Button_name:setTitleText(i18n("common_text_3155"))
	self.Button_name:addTouchEventListener(handler(self, self.onNameClick))
	self.Button_uid = SoraDGetChildByName(self, "Button_uid")
	self.Button_uid:setTitleText(i18n("UID"))
	self.Button_uid:addTouchEventListener(handler(self, self.onUIDClick))
	self.Button_alliance = SoraDGetChildByName(self, "Button_alliance")
	self.Button_alliance:setTitleText(i18n("common_text_069"))
	self.Button_alliance:addTouchEventListener(handler(self, self.onAllianceClick))
	self.nodeTitle:setTitle("")
	self.nodeTitle:setTitleSize()
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.txtFieldCode = SoraDGetChildByName(self, "TextField_search")
	self.txtFieldCode:setTextHorizontalAlignment(SoraDFLabelR())
	self.txtFieldCode:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	SoraDGetChildByName(self, "Button_announce"):removeFromParent()
	self.labelNotice:setVisible(false)
	self.labelNone:setVisible(false)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
	self.txtFieldCode = self:changeToEditBox(self.txtFieldCode)
	self:setSwitcher()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_APPOINTSEARCH_BACK", handler(self, self.initSearchData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_PLAYERGIFTSEARCH_BACK", handler(self, self.initSearchData))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SEARCH_LORD", handler(self, self.updateSearchData))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_GETLIST", handler(self, self.officialToLimit))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_SENDSUCCESS", handler(self, self.kingGiftSendSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMGIFT_GETLIST", handler(self, self.updateGiftNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_AWARD_GIFT_BACK", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_AWARD_GIFT_BACK", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_TREASURE", handler(self, self.onMsgUpdateAtlantisGift))
end
function WorldMapKingdomCityAppointSelect:setOfficialID(OfficialID, limitList)
	self.nodeTitle:setTitle(i18n("common_text_687"))
	self.officialID = OfficialID
	self.searchStyle = gSearchStyle.LORD_KINGDOM
	self.searchMode = lordSearchType.OFFICIAL_APPOINT
	lordInfoCtrl:searchLordInKingdomReq("", 1, self.searchMode)
	SoraDShowLoading(self)
	local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
	KWKingdomCtrl:getOfficialData(true, true)
	self:initLimitListMap()
end
function WorldMapKingdomCityAppointSelect:setLegendOfficialID(OfficialID, limitList, mapid)
