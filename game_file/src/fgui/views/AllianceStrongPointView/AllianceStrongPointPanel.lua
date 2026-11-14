local gametop = gModuleMgr.getObject("gametop")
local allianceStrontholdCtrl = gametop.playertop_:getModule("allianceStrontholdCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceStrongPointPanel = class("AllianceStrongPointPanel", baseFguiPanel)
function AllianceStrongPointPanel:ctor(...)
	AllianceStrongPointPanel.super.ctor(self, ...)
	print("AllianceStrongPointPanel:ctor", self.viewName)
end
function AllianceStrongPointPanel:onInit()
	print("=======AllianceStrongPointPanel:onInit")
	self.fields.Com_title:initData(i18n("alliance_stronghold_text_100"), handler(self, self.onClickClose))
	local Node_bonus = self.fields.Node_bonus
	Node_bonus:setString(i18n("alliance_stronghold_text_031"))
	Node_bonus:addClickListener(handler(self, self.onBtnBonusClick))
	if not SoraDFIsRA() then
		Node_bonus:getChild("title"):fixPos()
		Node_bonus:getChild("icon"):fixPos()
	end
	self.scroll = self.fields.List
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function AllianceStrongPointPanel:onShow()
	print("=======AllianceStrongPointPanel:onShow")
	allianceStrontholdCtrl:reqAllianceStrontholdList()
end
function AllianceStrongPointPanel:initData()
	self.strontholdList = allianceStrontholdCtrl:getHoldListByLv()
	self.scroll:setNumItems(#self.strontholdList)
end
function AllianceStrongPointPanel:onItemRenderer(index, obj)
	local _fields = obj._fields
	_fields = _fields or fguiHelper.get_fields(obj)
	local buildLv = index + 1
	_ENV = nil
	;(nil).var = buildLv
	_fields.Node_title:setString(i18n("alliance_stronghold_text_032", nil))
	local data = self.strontholdList[buildLv]
	if next(data) then
		_fields.Text_none:setVisible(false)
		_fields.List:setItemRenderer(function(_index, _obj)
			local _data = data[_index + 1]
			self:setSingleInfo(_obj, _data)
		end)
		_fields.List:setNumItems(#data)
		_fields.List:resizeToFit(#data)
	else
		_fields.Text_none:setVisible(true)
		_fields.Text_none:setString(i18n("common_text_480"))
		_fields.List:setVisible(false)
		local sSize = _fields.List:getContentSize()
		_fields.List:setContentSize(cc.size(sSize.width, 100))
	end
end
function AllianceStrongPointPanel:setSingleInfo(obj, data)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local _controllers = fguiHelper.get_controllers(obj)
	local Image_build = _fields.Node_build:getChild("Image_build")
	Image_build:setURL(data.png)
	local Text_unActive = _fields.Text_unActive:getChild("title")
	Text_unActive:setString(data.isActive and i18n("alliance_stronghold_text_101") or i18n("alliance_stronghold_text_102"))
	fguiHelper.setTextWidthHeight(Text_unActive, cc.size(200, 40))
	_controllers.c_active:setSelectedIndex(data.isActive and 0 or 1)
	local Text_name = _fields.Text_name
	Text_name:setString(data.name)
	local Text_pos = _fields.Text_pos
	_ENV = cc.size(200, 40)
	cc.size(200, 40).x = data.pos.x - 1
	cc.size(200, 40).y = data.pos.y - 1
	local posStr = i18n("common_text_2155", cc.size(200, 40))
	_ENV = cc.size(200, 40)
	cc.size(200, 40).u = true
	Text_pos:setString(SoraDWrapHtmlTagByStyle(posStr, cc.size(200, 40)))
	Text_pos:removeEventListeners()
	Text_pos:addClickListener(function()
		SoraDPlaySound()
		_ENV = nil
		;(nil).x = data.pos.x - 1
		;(nil).y = data.pos.y - 1
		SoraDGotoWorldMapPoint(nil, true)
		SoraDRemoveAllPanelFromManager()
	end)
	local List_attr = _fields.List_attr
	List_attr:setItemRenderer(function(_index, _obj)
		local _data = data.bonus[_index + 1]
		local _fields = _obj._fields
		if not _fields then
			_fields = fguiHelper.get_fields(_obj)
			_obj._fields = _fields
			if not SoraDFIsRA() then
				_obj:fixChildrenPos()
			end
		end
		local Text_bonusStr = _fields.Text_bonusStr
		local Text_bonusVal = _fields.Text_bonusVal
		Text_bonusStr:setString(_data.des)
		Text_bonusVal:setString(_data.val)
		local _controllers = fguiHelper.get_controllers(_obj)
		_controllers.c_active:setSelectedIndex(data.isActive and 0 or 1)
	end)
	List_attr:setNumItems(#data.bonus)
	if data.status == gKingdomWarStatusType.rule then
		_controllers.c_status:setSelectedIndex(0)
	else
		_controllers.c_status:setSelectedIndex(1)
	end
	Text_time = SoraDCreateTimerLabel(obj, _fields.Text_time)
	if data.status == gKingdomWarStatusType.rule then
		Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).var = time
			return i18n("alliance_stronghold_text_040", nil)
		end)
	else
		Text_time:setTimeLast(nil)
	end
	local leftTime = data.statusEndTime - serviceFunctions.systemTime()
	print("leftTime======", leftTime, data.pos.x, data.pos.y)
	if 0 < leftTime then
		Text_time:beginTime(leftTime)
		fguiHelper.setTextWidthHeight(Text_time, cc.size(580, 36))
	end
end
function AllianceStrongPointPanel:onBtnBonusClick()
	SoraDPlaySound()
	uiManager:show("AllianceStrongPointBonus")
end
return AllianceStrongPointPanel
