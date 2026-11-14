local gametop = gModuleMgr.getObject("gametop")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local atlantisSettingZeroView = class("atlantisSettingZeroView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisSettingZeroView")
	end
	return target
end)
function atlantisSettingZeroView:ctor()
	self.managerUidMap, gametop, self.shieldUidMap, gametop = nil, nil, nil, nil
	self.myUid = gametop.playertop_:getPlayerID()
	self:initWidget()
	atlantisActivityCtrl:reqGetLv0List()
	SoraDShowLoading(self)
end
function atlantisSettingZeroView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_LV0_REFRESH", handler(self, self.refreshView))
end
function atlantisSettingZeroView:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("atlantiswar_text_0346"))
	self.ccs_title.Node_style_bg:setPositionX(SoraDFPosX(0, 640))
	self.scroll = SoraDCreatePanelByCloneNode(self.Top_Size_ScrollView, "commonAutoScrollList")
	self.scroll:setSingleCCS("atlantisSettingZeroSingle")
	self.Button_add:setTitleText(i18n("shopping_text_10"))
	self.Button_add:addTouchEventListener(handler(self, self.btnAddClick))
	local constantRead = include("constantRead")
	local num = constantRead.getConstValue("ATLANTISWAR_TEAM_MEMBER_R0", 50)
	_ENV = handler(self, self.btnAddClick)
	handler(self, self.btnAddClick).num = num
	self.Text_des:setString(i18n("atlantiswar_text_0349", handler(self, self.btnAddClick)))
	self.Center_Text_noInfo:setString(i18n("common_text_3416"))
end
function atlantisSettingZeroView:initData()
	local lv0List = self:getLv0List()
	local singleSize = cc.size(320, 260)
	local widthNum = 2
	local customHeight = singleSize.height * math.ceil(#lv0List / widthNum) + 44
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).viewType = "atlantisManagerSingle"
	;(nil).customHeight = customHeight
	self.scroll:updateScrollView(singleSize, lv0List, widthNum, nil)
	self.Center_Text_noInfo:setVisible(#lv0List == 0)
end
function atlantisSettingZeroView:refreshView(target, event)
	if event.err == gErrDef.Err_ATLANTIS_WAR_NOT_ADMIN then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	SoraDCloseLoading(self)
	self:initData()
	local scrollInner = self.scroll:getInnerContainer()
	if scrollInner:getPositionY() > 0 then
		scrollInner:setPositionY(0)
	end
end
function atlantisSettingZeroView:btnAddClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.managerUidMap[self.myUid] then
			SoraDShowMsgTip(i18n("notice_0205"))
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
		if atlantisActivityCtrl:getActivityCurState() ~= ATLANTIS_WAR_STATE.SETTEAM then
			local atlantisWarUtil = include("atlantisWarUtil")
			if atlantisWarUtil.isNewMap() then
				SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020_KOH"))
			else
				SoraDShowHelpMsgTip(i18n("atlantiswar_text_0020"))
			end
			return
		end
		local layer = uiManager:show("LordSelectView").view
		_ENV = i18n("atlantiswar_text_0020")
		i18n("atlantiswar_text_0020").title = i18n("atlantiswar_text_0346")
		i18n("atlantiswar_text_0020").shieldUidMap = self.shieldUidMap
		i18n("atlantiswar_text_0020").handle = function(tableUID)
			atlantisActivityCtrl:reqAddLv0User(tableUID[1])
		end
		layer:setStyleAtlantisSettingZero(i18n("atlantiswar_text_0020"))
	end
end
function atlantisSettingZeroView:getLv0List()
	local self.shieldUidMap, atlantisActivityCtrl, atlantisActivityCtrl, list
	if not atlantisActivityCtrl:getLv0List() then
		local atlantisActivityCtrl, lv0List = atlantisActivityCtrl:getLv0List(), atlantisActivityCtrl:getLv0List()
	end
	for i, v in pairs(lv0List) do
		table.insert(list, v)
		self.shieldUidMap[v.uid] = true
	end
	table.sort(list, function(a, b)
		if a.time ~= b.time then
			return a.time > b.time
		end
		return a.uid < b.uid
	end)
	if not atlantisActivityCtrl:getManagerInfo() then
		local atlantisActivityCtrl, managerInfo = atlantisActivityCtrl:getManagerInfo(), atlantisActivityCtrl:getManagerInfo()
	end
	if managerInfo.managers then
		for i, v in pairs(managerInfo.managers) do
			self.managerUidMap[v.uid] = true
		end
	end
	if managerInfo.adminInfo then
		self.managerUidMap[managerInfo.adminInfo.uid] = true
	end
	for uid, v in pairs(self.managerUidMap) do
		self.shieldUidMap[uid] = true
	end
	return list
end
return atlantisSettingZeroView
