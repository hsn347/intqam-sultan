local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_TechDetailPanel = class("RoaringFlame_TechDetailPanel", baseFguiPanel)
function RoaringFlame_TechDetailPanel:ctor(...)
	RoaringFlame_TechDetailPanel.super.ctor(self, ...)
	print("RoaringFlame_TechDetailPanel:ctor", self.viewName)
end
function RoaringFlame_TechDetailPanel:onInit()
	print("=======RoaringFlame_TechDetailPanel:onInit")
	self.condition, _ENV = print, print
	self.fields.Label_title:setString(i18n("common_text_726"))
	self.fields.Text_left:setString(i18n("common_text_1663"))
	self.fields.Text_max:setString(i18n("common_text_3900"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_study:setString(i18n("common_text_062"))
	self.fields.Button_study:addClickListener(handler(self, self.btnStudyClick))
	self.fields.Text_left:fixPos()
	self.fields.Bar:fixPos()
end
function RoaringFlame_TechDetailPanel:onItemRenderer(index, obj)
	obj:initData(self.condition[index + 1])
end
function RoaringFlame_TechDetailPanel:onShow()
	print("=======RoaringFlame_TechDetailPanel:onShow")
	self.tid = self.param.tid
	self.cfg = roaringFlameWarRead.getTechnologyCfg(self.tid, 0)
	self.fields.Panel_bg:setString(i18n(self.cfg.name))
	self:initData()
end
function RoaringFlame_TechDetailPanel:initData()
	self.fields.Com_tech:initData(self.tid)
	self.isMaxLv = roaringFlameWarCtrl:getTechnologyLv(self.tid) >= self.cfg.max_level
	if self.isMaxLv then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.isStudying, self.beginTime = roaringFlameWarCtrl:isTechnologyStudying(self.tid)
		local leftTime = (self.beginTime or 0) + self.cfg.technology_time - serviceFunctions.systemTime()
		if self.isStudying and 0 < leftTime then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Bar:setTime(leftTime, self.cfg.technology_time)
		else
			self.controllers.c1:setSelectedIndex(0)
			self.condition = roaringFlameWarCtrl:getTechPrefix(self.tid)
			self.fields.List:setNumItems(#self.condition)
			self.fields.Button_study:setBeginTime(self.cfg.technology_time)
			self.checkTip = self:checkStudyCondition()
			if self.checkTip then
				self.fields.Button_study:setBright(false)
			else
				self.fields.Button_study:setBright(true)
			end
		end
	end
end
function RoaringFlame_TechDetailPanel:checkStudyCondition()
	local tip
	if roaringFlameWarCtrl:isTechnologyStudying() then
		tip = i18n("flames_dunes_text81")
	else
		local lv = 0
		if lv >= self.cfg.max_level then
			tip = i18n("flames_dunes_text82")
		else
			local ret = roaringFlameWarCtrl:checkTechPrefix(self.tid)
			if ret ~= 0 then
				if ret == 2 then
					tip = i18n("flames_dunes_text296")
				else
					tip = i18n("flames_dunes_text80")
				end
			end
		end
	end
	return tip
end
function RoaringFlame_TechDetailPanel:btnStudyClick()
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.UPGRADE_TECHNOLOGY, true) then
		return
	end
	if self.checkTip then
		SoraDShowMsgTip(self.checkTip)
		return
	end
	roaringFlameWarCtrl:reqResearchTech(self.tid)
	self:close()
end
return RoaringFlame_TechDetailPanel
