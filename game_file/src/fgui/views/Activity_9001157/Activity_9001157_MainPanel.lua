local gametop = gModuleMgr.getObject("gametop")
local outStandingsRead = include("outStandingsRead")
local outStandingsCtrl = gametop.playertop_:getModule("outStandingsCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001157_MainPanel = class("Activity_9001157_MainPanel", baseFguiPanel)
_ENV = "Activity_9001157_MainPanel"
;("Activity_9001157_MainPanel").COMBAT_POWER = 1
;("Activity_9001157_MainPanel").BUILDINGS_POWER = 2
local _ENV, ("Activity_9001157_MainPanel").TECHNOLOGY_POWER, powerTotalDef = baseFguiPanel, 3, "Activity_9001157_MainPanel"
_ENV = nil
;(nil).key = "Outstanding_title_03"
;(nil).text = "Outstanding_text_03"
;(nil).color = cc.c3b(255, 200, 100)
baseFguiPanel[powerTotalDef.COMBAT_POWER], (nil).png = nil, "frame_asqx_titlebg_01.png"
_ENV = nil
;(nil).key = "Outstanding_title_04"
;(nil).text = "Outstanding_text_04"
;(nil).color = cc.c3b(106, 218, 255)
baseFguiPanel[powerTotalDef.BUILDINGS_POWER], (nil).png = nil, "frame_asqx_titlebg_02.png"
_ENV = nil
;(nil).key = "Outstanding_title_05"
;(nil).text = "Outstanding_text_05"
;(nil).color = cc.c3b(161, 255, 128)
baseFguiPanel[powerTotalDef.TECHNOLOGY_POWER], (nil).png = nil, "frame_asqx_titlebg_03.png"
local powerTotal = baseFguiPanel
function Activity_9001157_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001157_MainPanel:ctor", self.viewName)
end
function Activity_9001157_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001157_MainPanel:onInit()
	print("=======Activity_9001157_MainPanel:onInit")
	self.fields.Text_ins:fixPos()
	self.fields.Text_reset:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Com_title:initData(i18n("activity_name_9001157"), handler(self, self.onClickClose), handler(self, self.buttonClickCallBack))
	self.fields.Com_title:initCommonActivityTime(gActivityTimeActivityID.OUTS_STANDINGS)
	self.fields.Text_reset:setString(i18n("activity_outstanding_desc"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	_ENV = i18n("common_text_2193")
	i18n("common_text_2193").power = ""
	self.fields.Text_des:setString(i18n("common_text_1418", i18n("common_text_2193")))
	_ENV = i18n("common_text_1418", i18n("common_text_2193"))
	_ENV, _ENV, i18n("common_text_1418", i18n("common_text_2193")).defaultClick = i18n("common_text_1418", i18n("common_text_2193"))
	i18n("common_text_1418", i18n("common_text_2193")).title = i18n("Outstanding_title_01")
	_ENV, i18n("common_text_1418", i18n("common_text_2193"))[1], i18n("common_text_1418", i18n("common_text_2193")).tag = i18n("common_text_1418", i18n("common_text_2193"))
	i18n("common_text_1418", i18n("common_text_2193")).title = i18n("Outstanding_title_02")
	i18n("common_text_1418", i18n("common_text_2193")).tabsetArray, i18n("common_text_1418", i18n("common_text_2193"))[2], i18n("common_text_1418", i18n("common_text_2193")).tag = i18n("common_text_1418", i18n("common_text_2193"))
	i18n("common_text_1418", i18n("common_text_2193")).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(i18n("common_text_1418", i18n("common_text_2193")))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List_Rank:setItemRenderer(handler(self, self.onItemRankRender))
end
function Activity_9001157_MainPanel:onShow()
	print("=======Activity_9001157_MainPanel:onShow")
	outStandingsCtrl:sendInitMsg()
	SoraDShowLoading(self)
end
function Activity_9001157_MainPanel:initScroll()
	local ret, tmpRetNum, retNum = outStandingsCtrl:getReceiveStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(1, ret, retNum)
	self.beginIndex = 1
	self.fields.List:setNumItems(#powerTotal)
	local kingdomName = ""
	local kingdomList = outStandingsCtrl:getKingdomList()
	local targetPower = outStandingsRead:getNeedFloorPoint(outStandingsCtrl:getFloorType())
	for i, v in ipairs(kingdomList) do
		if i ~= #kingdomList then
			kingdomName = kingdomName .. v .. ","
		else
			kingdomName = kingdomName .. v
		end
	end
	outStandingsCtrl = outStandingsCtrl:getFloorType()
	outStandingsCtrl:getFloorType().num = kingdomName
	outStandingsCtrl, outStandingsCtrl, outStandingsCtrl:getFloorType().num2 = v, kingdomName, targetPower
	outStandingsCtrl, kingdomName.num, v.color = v, v, "#FFC864"
	kingdomName.num2, v.color = v, "#FFC864"
	self.fields.Text_ins:setString(i18n_html("Outstanding_text_09", outStandingsCtrl:getFloorType()))
end
function Activity_9001157_MainPanel:initRankScroll()
	self.rankList = outStandingsCtrl:getRankingInfo()
	self:initMyData()
	self.fields.List_Rank:setNumItems(#self.rankList)
end
function Activity_9001157_MainPanel:initMyData()
	self.fields.Com_OwnRank:updateView()
end
function Activity_9001157_MainPanel:onItemRender(index, target)
	self.beginIndex = self.beginIndex + target:initData(powerTotal[index + 1], index + 1, self.beginIndex)
end
function Activity_9001157_MainPanel:onItemRankRender(index, target)
	_UPVALUE0_ = index + 1
	;(index + 1).index = index + 1
	target:initData(self.rankList[index + 1], index + 1)
end
function Activity_9001157_MainPanel:onTabClick(tag)
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function Activity_9001157_MainPanel:buttonClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).num = 100
	local comStr = i18n("Outstanding_text_01", nil)
	_ENV = nil
	;(nil).float = SoraDFLabelR()
	SoraDShowHelpMsgTip(comStr, nil)
end
return Activity_9001157_MainPanel
