local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local buildCreateResBuyPanel = class("buildCreateResBuyPanel", baseFguiPanel)
function buildCreateResBuyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("buildCreateResBuyPanel:ctor", self.viewName)
end
function buildCreateResBuyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function buildCreateResBuyPanel:onInit()
	print("=======buildCreateResBuyPanel:onInit")
	self.tableNeedResData, _ENV = print, print
	self.viewType = RESBUYVIEW_TYPE.BUILD
	self.handleCallBack = nil
	self.fields.Text_needRes:setString(i18n("common_text_762"))
	self.fields.Spine_girl:setEffectPath("spine/madeling.skel", "gaoxing", true)
	self.fields.btnNow:addClickListener(handler(self, self.btnNowClickCallBack))
	self.fields.List_res:setItemRenderer(handler(self, self.onResRenderer))
end
function buildCreateResBuyPanel:onShow()
	print("=======buildCreateResBuyPanel:onShow")
	self.tableNeedResData = self.param.needResData
	self.viewType = self.param.viewType or RESBUYVIEW_TYPE.BUILD
	self.handleCallBack = self.param.handle
	self:initView()
end
function buildCreateResBuyPanel:onResRenderer(index, obj)
	local data = self.tableNeedResData.retCostRes[index + 1]
	obj:setIcon(publicRead.getIcon(data.resid))
	obj:setTitle(SoraDConvertNumberWithUnit(math.abs(data.rescount)))
end
function buildCreateResBuyPanel:initView()
	local desStr = i18n("common_text_756")
	local btnNowStr = i18n("common_text_042")
	if self.viewType == RESBUYVIEW_TYPE.BUILD then
		desStr = i18n("common_text_756")
		btnNowStr = i18n("common_text_042")
	elseif self.viewType == RESBUYVIEW_TYPE.UPGRADE then
		desStr = i18n("common_text_757")
		btnNowStr = i18n("common_text_055")
	elseif self.viewType == RESBUYVIEW_TYPE.TRAIN_ARMY then
		desStr = i18n("common_text_758")
		btnNowStr = i18n("common_text_061")
	elseif self.viewType == RESBUYVIEW_TYPE.TRAIN_TRAP then
		desStr = i18n("common_text_759")
		btnNowStr = i18n("common_text_042")
	elseif self.viewType == RESBUYVIEW_TYPE.HEAL_ARMY then
		desStr = i18n("common_text_760")
		btnNowStr = i18n("common_text_065")
	elseif self.viewType == RESBUYVIEW_TYPE.STUDY_SCIENCE then
		desStr = i18n("common_text_761")
		btnNowStr = i18n("common_text_062")
	elseif self.viewType == RESBUYVIEW_TYPE.EQUIP_BAPTIZE then
		desStr = i18n("common_text_1365")
		btnNowStr = i18n("common_text_1341")
	elseif self.viewType == RESBUYVIEW_TYPE.EQUIP_INTENSIFY then
		desStr = i18n("common_text_1364")
		btnNowStr = i18n("common_text_1340")
	elseif self.viewType == RESBUYVIEW_TYPE.PROMOTE_ARMY then
		desStr = i18n("arms_promotion_text_05")
		btnNowStr = i18n("arms_promotion_btn_01")
	elseif self.viewType == RESBUYVIEW_TYPE.UPGRADE_STAR then
		desStr = i18n("Glory_text_21")
		btnNowStr = i18n("Glory_text_10")
	elseif self.viewType == RESBUYVIEW_TYPE.BUILD_STATUE_BRAVE then
		desStr = i18n("Soldiers_armor_text_66")
		btnNowStr = i18n("ice_carnival_text03")
	elseif self.viewType == RESBUYVIEW_TYPE.WAR_GEM_REPLACE then
		desStr = i18n("common_text_4625")
		btnNowStr = i18n("common_text_1417")
	elseif self.viewType == RESBUYVIEW_TYPE.MGAGIC_LAMP_STRENGTH then
		desStr = i18n("magic_lamp_text_039")
		btnNowStr = i18n("magic_lamp_text_006")
	elseif self.viewType == RESBUYVIEW_TYPE.MGAGIC_LAMP_CLASS then
		desStr = i18n("magic_lamp_text_039")
		btnNowStr = i18n("magic_lamp_text_008")
	elseif self.viewType == RESBUYVIEW_TYPE.MGAGIC_LAMP_HATCH then
		desStr = i18n("Jinn_hatch_text_35")
		btnNowStr = i18n("Jinn_hatch_text_18")
	end
	self.fields.Text_des:setString(desStr)
	self.fields.btnNow:setString(btnNowStr)
	self.fields.btnNow:setCostNum(self.tableNeedResData.resToGold, SoraDGetGold())
	self.fields.List_res:setNumItems(#self.tableNeedResData.retCostRes)
end
function buildCreateResBuyPanel:btnNowClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.tableNeedResData.resToGold) then
		if self.handleCallBack then
			self.handleCallBack()
		end
		self:close()
	end
end
return buildCreateResBuyPanel
