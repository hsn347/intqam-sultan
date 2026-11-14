local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_ChoosePanel = class("Activity_9001573_ChoosePanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local constantRead = include("constantRead")
function Activity_9001573_ChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001573_ChoosePanel:ctor", self.viewName)
	self.debug = true
	self.memberList, _ENV, self.showViewKid = gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID()
end
function Activity_9001573_ChoosePanel:onInit()
	print("=======Activity_9001573_ChoosePanel:onInit")
	self.curSortType = 1
	self.nextIndex = 1
	self.commanderLimit = constantRead.getConstValue("CELESTIAL_DEFENSE_COMMANDER", 3)
	self.fields.Com_title:initData(i18n("Celestial_defense_text_013"), handler(self, self.onClickClose))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.Text_input = self.fields.TextField_search
	self.Text_input:setMaxLength(MAX_NICKNAME_LEN)
	_UPVALUE2_, _ENV = handler(self, self.onClickBtnSearch)
	_UPVALUE2_, handler(self, self.onClickBtnSearch).items, handler(self, self.onClickBtnSearch)[1] = handler(self, self.onClickBtnSearch)
	_UPVALUE2_, handler(self, self.onClickBtnSearch).items, handler(self, self.onClickBtnSearch)[2] = handler(self, self.onClickBtnSearch)
	handler(self, self.onClickBtnSearch).values, handler(self, self.onClickBtnSearch)[1] = handler(self, self.onClickBtnSearch)
	handler(self, self.onClickBtnSearch).values, handler(self, self.onClickBtnSearch)[2] = handler(self, self.onClickBtnSearch)
	handler(self, self.onClickBtnSearch).selectedValue = self.curSortType
	handler(self, self.onClickBtnSearch).changedCallback = handler(self, self.onChooseClick)
	self:setComboBox(self.fields.ComboBox_sort, handler(self, self.onClickBtnSearch))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.Text_input:fixPos()
	self.fields.textbg:fixPos()
	self.fields.Button_search:fixPos()
	self.fields.ComboBox_sort:fixPos()
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.List_player:setVirtual()
	self.fields.List_player:setItemRenderer(handler(self, self.onPlayerItemRederer))
	self.fields.List_player:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
end
function Activity_9001573_ChoosePanel:onShow()
	print("=======Activity_9001573_ChoosePanel:onShow")
	self:req4Data()
	self:refreshTextRemain()
end
function Activity_9001573_ChoosePanel:onChooseClick(button, event)
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox_sort:getValue())
end
function Activity_9001573_ChoosePanel:onClickHelp(...)
	SoraDPlaySound()
end
function Activity_9001573_ChoosePanel:refreshTextRemain(...)
	local remain = self.commanderLimit - activity_9001573_Ctrl:getCommanderNum()
	activity_9001573_Ctrl = nil
	;(nil).num = remain
	self.fields.Text_num:setTitle(i18n("Celestial_defense_text_045", nil))
end
function Activity_9001573_ChoosePanel:onClickBtnSearch(...)
	SoraDPlaySound()
	local name = self.Text_input:getText()
	local teamDef = include("teamDef")
	if teamDef.namkVailidCheck(name) or name == "" then
		self.memberList, _ENV = teamDef.namkVailidCheck(name), teamDef.namkVailidCheck(name)
		self.nextIndex = 1
		self:req4Data(name)
	else
		SoraDShowMsgTip(i18n("notice_0071"))
	end
end
function Activity_9001573_ChoosePanel:onPlayerItemRederer(index, obj)
	local memberData = self.memberList[index + 1]
	obj:initData(memberData)
end
function Activity_9001573_ChoosePanel:scrollEventCallBack(target, event)
	if self.nextIndex then
		self:req4Data(self.lastSearchName or "")
	end
end
function Activity_9001573_ChoosePanel:req4Data(name)
	lordInfoCtrl:searchLordInThisKingdomReq(name or "", self.nextIndex, gametop.playertop_:getMapID(), self.curSortType == 2 and tonumber(name) or nil, lordSearchType.PIGEON)
	self.lastSearchName = name
	SoraDShowLoading(self:displayObject())
end
function Activity_9001573_ChoosePanel:refreshMemberList(memberList)
	if not self.memberList then
		_ENV = self.memberList
	end
	self.memberList = self.memberList
	for i, v in ipairs(memberList) do
		table.insert(self.memberList, v)
	end
	self.fields.List_player:setNumItems(#self.memberList)
	if #self.memberList > 0 then
		self.fields.Text_notice:setVisible(false)
	else
		self.fields.Text_notice:setVisible(true)
	end
end
return Activity_9001573_ChoosePanel
