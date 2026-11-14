_UPVALUE5_ = nil
;(nil)[1] = gIDDef.METEOR_CRYSTAL
;(nil)[2] = gIDDef.LEGEND_CRYSTAL
;(nil)[3] = gIDDef.NEBULA_CRYSTAL
;(nil)[4] = gIDDef.GILDED_CRYSTAL
local (nil)[5], crystalList = gIDDef.GILDED_CURE_ESSENCE, nil
local baseComponent = require("fgui.base.baseComponent")
local Com_HV_res = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://BuildMedicalTent/Com_HV_res", Com_HV_res)
fgui.register_extension("ui://BuildMedicalTent/Com_HV_res2", Com_HV_res)
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local resDesRead = include("resDesRead")
function Com_HV_res:onInit()
	self:fixChildrenPos()
	self.tableResData, _ENV, self.needResList, _ENV = self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos, self.fixChildrenPos
	self.fields.panel:addEventListener(fgui.UIEventType.Click, handler(self, self.panelClick))
end
function Com_HV_res:onShow()
end
function Com_HV_res:initData(itemData, needResList)
	self.tableResData = itemData
	self.needResList = needResList
	local rescount = SoraDPreciseDecimal(self.tableResData.rescount, 1)
	local resImg = resDesRead.getIcon(self.tableResData.resid)
	self.fields.icon:setURL(resImg)
	if SoraDisInList(self.tableResData.resid, crystalList) then
		self.fields.panel:setURL("frame_common_xiaohaobg_01.png")
	else
		self.fields.panel:setURL("frame_common_xiaohaobg.png")
	end
	local needColor = "#D7C39B"
	if self.tableResData.isreach == nil then
		if self.tableResData.rescount > self.tableResData.curcount then
			needColor = "#EA1716"
		end
	elseif self.tableResData.isreach == false then
		needColor = "#EA1716"
	elseif itemData.rescount < itemData.curcount then
		needColor = "#EA1716"
	end
	_ENV = nil
	;(nil).var1 = SoraDConvertNumberWithUnit(rescount)
	_ENV, _ENV, (nil).var2 = self.tableResData.curcount, SoraDConvertNumberWithUnit(self.tableResData.curcount), SoraDConvertNumberWithUnit(self.tableResData.curcount)
	SoraDConvertNumberWithUnit(self.tableResData.curcount).var1, self.tableResData.curcount.color = self.tableResData.curcount, needColor
	local str = i18n_html("%{var1}/%{var2}", nil, (SoraDConvertNumberWithUnit(self.tableResData.curcount)))
	self.fields.txtHave:setString(str)
end
function Com_HV_res:returnDeta(...)
	return cityCtrl:getResCount(self.tableResData.resid) - self.tableResData.rescount
end
function Com_HV_res:updateResource(needResList)
	self.needResList = needResList
	cityCtrl = nil
	;(nil).resid = self.tableResData.resid
	;(nil).rescount = self.tableResData.rescount
	;(nil).curcount = cityCtrl:getResCount(self.tableResData.resid)
	self:initData(nil, self.needResList)
end
function Com_HV_res:panelClick(clickObj, type)
	SoraDPlaySound()
	if SoraDisInList(self.tableResData.resid, crystalList) then
		if gIDDef.METEOR_CRYSTAL == self.tableResData.resid or gIDDef.GILDED_CRYSTAL == self.tableResData.resid or gIDDef.GILDED_CURE_ESSENCE == self.tableResData.resid then
			_ENV = nil
			;(nil).rid = self.tableResData.resid
			;(nil).needResData = self.needResList
			uiManager:show("meteorBuyView", nil)
		else
			local panel = SoraDCreatePanel("legendCrystalPopView")
			panel:initCrystalID(self.tableResData.resid)
			panel:show()
		end
	else
		_ENV = self.tableResData.resid
		self.tableResData.resid.rid = self.tableResData.resid
		self.tableResData.resid.needResData = self.needResList
		uiManager:show("resourceBuyView", self.tableResData.resid)
	end
end
return Com_HV_res
