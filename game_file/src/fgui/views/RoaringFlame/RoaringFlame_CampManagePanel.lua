local gametop = gModuleMgr.getObject("gametop")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarRead = include("roaringFlameWarRead")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_CampManagePanel = class("RoaringFlame_CampManagePanel", baseFguiPanel)
function RoaringFlame_CampManagePanel:ctor(...)
	RoaringFlame_CampManagePanel.super.ctor(self, ...)
	print("RoaringFlame_CampManagePanel:ctor", self.viewName)
end
function RoaringFlame_CampManagePanel:onInit()
	print("=======RoaringFlame_CampManagePanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text63"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_build:setString(i18n("flames_dunes_text71"))
	self.fields.Btn_build:addClickListener(handler(self, self.btnBuildClick))
	self.fields.Btn_war:setString(i18n("flames_dunes_text76"))
	self.fields.Btn_war:addClickListener(handler(self, self.btnWarClick))
	self.fields.Btn_tech:setString(i18n("flames_dunes_text69"))
	self.fields.Btn_tech:addClickListener(handler(self, self.btnTechClick))
	_ENV, _ENV = self.fields.Btn_tech, self.fields.Btn_tech.addClickListener
	self.fields.Btn_tech.enum = 2
	self.fields.Btn_tech.png = "frame_9001674_zhankuang.png"
	_ENV, self.fields.Btn_tech.addClickListener[1], self.fields.Btn_tech.title = self.fields.Btn_tech, self.fields.Btn_tech, i18n("flames_dunes_text75")
	self.fields.Btn_tech.enum = 3
	self.fields.Btn_tech.png = "frame_9001674_guanli.png"
	_ENV, self.fields.Btn_tech.addClickListener[2], self.fields.Btn_tech.title = self.fields.Btn_tech, self.fields.Btn_tech, i18n("flames_dunes_text72")
	self.fields.Btn_tech.enum = 4
	self.fields.Btn_tech.png = "frame_9001674_gonggao.png"
	self.enumList, self.fields.Btn_tech.addClickListener[3], self.fields.Btn_tech.title = self.fields.Btn_tech.addClickListener, self.fields.Btn_tech, i18n("flames_dunes_text70")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.icon_build:fixPos()
	self.fields.icon_build:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_name:fixPos()
	self.fields.Text_leader:fixPos()
	self.fields.Text_score:fixPos()
	self.fields.Text_buildNum:fixPos()
	self.fields.Text_member:fixPos()
end
function RoaringFlame_CampManagePanel:onShow()
	print("=======RoaringFlame_CampManagePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	local selfKid = gametop.playertop_:getKingdomID()
	local modelImg = kingdomCtrl:getKindomPalaceModelImg(selfKid)
	self.fields.icon_build:setURL(modelImg)
	local camp = roaringFlameWarCtrl:getSelfCamp()
	local campName = roaringFlameWarRead.getCampName(camp)
	local campStr = fguiHelper.getColorString("#F0E6D2", campName)
	_ENV = nil
	;(nil).name = campStr
	self.fields.Text_name:setString(i18n("flames_dunes_text64", nil))
	roaringFlameWarCtrl:reqCampManageData()
end
function RoaringFlame_CampManagePanel:initData(rspdata)
	if not rspdata.adminInfo then
		local gametop, adminInfo = rspdata.adminInfo, rspdata.adminInfo
	end
	local selfKid = gametop.playertop_:getKingdomID()
	gametop = gametop.playertop_
	local gametop.playertop_.color, style = "#F0E6D2", gametop.playertop_
	local leaderStr = SoraDWrapHtmlTagByStyle(adminInfo.nickName, style)
	local kidStr = SoraDWrapHtmlTagByStyle(selfKid, style)
	gametop = nil
	;(nil).name = leaderStr
	;(nil).kid = kidStr
	self.fields.Text_leader:setString(i18n("flames_dunes_text65", nil))
	local campScore = rspdata.campScore or 0
	local scoreStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(campScore), style)
	local rank = rspdata.rank or 0
	if 0 < campScore then
		local rankStr = SoraDWrapHtmlTagByStyle(rank, style)
		gametop = i18n("flames_dunes_text65", nil)
		i18n("flames_dunes_text65", nil).val1 = scoreStr
		i18n("flames_dunes_text65", nil).val2 = rankStr
		self.fields.Text_score:setString(i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil)))
	else
		gametop = i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil))
		i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil)).val1 = scoreStr
		self.fields.Text_score:setString(i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil))))
	end
	local occupyCount = rspdata.occupyCount or 0
	local countStr = SoraDWrapHtmlTagByStyle(occupyCount, style)
	gametop = i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil)))
	i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil))).val1 = countStr
	self.fields.Text_buildNum:setString(i18n("flames_dunes_text67", i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil)))))
	local playerCount = rspdata.playerCount or 0
	local countStr = SoraDWrapHtmlTagByStyle(playerCount, style)
	gametop = i18n("flames_dunes_text67", i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil))))
	i18n("flames_dunes_text67", i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil)))).num = countStr
	self.fields.Text_member:setString(i18n("flames_dunes_text68", i18n("flames_dunes_text67", i18n("flames_dunes_text288", i18n("flames_dunes_text66", i18n("flames_dunes_text65", nil))))))
	self.fields.List:setNumItems(#self.enumList)
	self:updateRed()
end
function RoaringFlame_CampManagePanel:updateRed()
	self.fields.Btn_tech:setReddot(roaringFlameWarCtrl:isHaveTechPointReward())
end
function RoaringFlame_CampManagePanel:btnBuildClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlameWar_CampBuild")
end
function RoaringFlame_CampManagePanel:btnWarClick()
	SoraDPlaySound()
	uiManager:show("AllianceWarView")
end
function RoaringFlame_CampManagePanel:btnTechClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_technology")
end
function RoaringFlame_CampManagePanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_RankInfo")
end
function RoaringFlame_CampManagePanel:onItemRenderer(index, obj)
	obj:initData(self.enumList[index + 1])
	obj:setHandle(handler(self, self.btnManagerClick))
end
function RoaringFlame_CampManagePanel:btnManagerClick(cfg)
	if cfg.enum == 2 then
		uiManager:show("RoaringFlameMapView")
	elseif cfg.enum == 3 then
		local curState = roaringFlameWarCtrl:getCurState()
		if curState >= ROARING_FLAME_WAR_STATE.SETTLE then
			SoraDShowMsgTip(i18n("flames_dunes_push78"))
		else
			uiManager:show("RoaringFlame_Team")
		end
	elseif cfg.enum == 4 then
		local curState = roaringFlameWarCtrl:getCurState()
		if curState >= ROARING_FLAME_WAR_STATE.SETTLE then
			SoraDShowMsgTip(i18n("flames_dunes_push78"))
		else
			uiManager:show("RoaringFlame_Notice")
			_ENV = roaringFlameWarCtrl
			roaringFlameWarCtrl.byUID = true
			SoraDConfigSet("Game:RoaringFlame_notice:readTime~integer", roaringFlameWarCtrl:getNoticeLastTime(), roaringFlameWarCtrl)
			self.fields.List:setNumItems(#self.enumList)
		end
	end
end
function RoaringFlame_CampManagePanel:onMsgUpdateCampManageData(target, event)
	if not event.rspdata then
		local _UPVALUE0_, rspdata = event.rspdata, event.rspdata
	end
	self:initData(rspdata)
end
return RoaringFlame_CampManagePanel
