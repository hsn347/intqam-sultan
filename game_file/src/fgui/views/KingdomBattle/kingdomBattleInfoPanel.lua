local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleInfoPanel = class("kingdomBattleInfoPanel", baseFguiPanel)
function kingdomBattleInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleInfoPanel:ctor", self.viewName)
end
function kingdomBattleInfoPanel:onInit()
	print("=======kingdomBattleInfoPanel:onInit")
	self.fields.Panel_bg:setString(i18n("warSecrit_text_17"))
	self.txtTitleScore = self.fields.Text_title_score
	self.txtTitlePro = self.fields.Text_title_pro
	if not SoraDFIsRA() then
		self.txtTitleScore:fixPos()
		self.txtTitlePro:fixPos()
	end
	self.scroll = self.fields.Size_ScrollView_item
	self.scroll:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.txtTitleScore:setString(i18n("warSecrit_text_18"))
	self.txtTitlePro:setString(i18n("warSecrit_text_19"))
	local pro = constantRead.getConstValue("GENERAL_ALLIANCE_GET_PRO", 0.8)
	_ENV = i18n("warSecrit_text_19")
	i18n("warSecrit_text_19").num = pro
	self.fields.Text_tips:setString(i18n("common_text_4709", i18n("warSecrit_text_19")))
	self:initView()
end
function kingdomBattleInfoPanel:onShow()
	print("=======kingdomBattleInfoPanel:onShow")
end
function kingdomBattleInfoPanel:onNormalItemRederer(index, obj)
	local data = self.data[index + 1]
	local txtTitleScore = obj:getChild("Text_single_score")
	local txtTitlePro = obj:getChild("Text_single_pro")
	if not SoraDFIsRA() then
		txtTitleScore:fixPos()
		txtTitlePro:fixPos()
	end
	local str
	local condition = data.condition
	if condition then
		if condition[1] <= 0 then
			_ENV = nil
			;(nil).num = condition[2]
			str = i18n("%{num}", nil)
		elseif condition[2] >= 90000000 then
			str = i18n("worldwar_text_19")
		else
			str = tostring(condition[1]) .. " -- " .. tostring(condition[2])
		end
	end
	if str then
		txtTitleScore:setString(str)
	end
	txtTitlePro:setString(data.scoreproportion / 1000)
end
function kingdomBattleInfoPanel:initView()
	local data = _G.require_data("conquestwar_killscoreconf", true).data
	self.data = data
	self.scroll:setNumItems(#self.data)
end
return kingdomBattleInfoPanel
