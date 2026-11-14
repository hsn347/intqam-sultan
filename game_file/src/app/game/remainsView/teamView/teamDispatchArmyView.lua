local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarUtil = include("remainsWarUtil")
local armyltCtrl = include("armyltCtrl")
local constantRead = include("constantRead")
local teamDispatchArmyView = class("teamDispatchArmyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamDispatchArmyView")
	end
	return target
end)
_ENV = "teamDispatchArmyView"
;("teamDispatchArmyView").teamCreate = 1
;("teamDispatchArmyView").teamAdd = 2
;("teamDispatchArmyView").teamAdjust = 3
local ("teamDispatchArmyView").teamInvitedAdd, dispatchType = 4, "teamDispatchArmyView"
function teamDispatchArmyView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.tableArmyData, _ENV, self.tableArmy, _ENV, self.tableSpare, _ENV, self.tableArmySingle, _ENV, self.dispatchType = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), nil
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local ruins_buff_value_add = buffCtrl:getBuffEffect(gBuffEffect.RUINS_WAR_MARCH_VALUE_LIMIT_BOOST) or 0
	local tech_warTech = technologyCtrl:getTechnoDataByID(140012, TECHNOLOGY_ATTR.warcommand)
	local ruins_tech_value_add = 0
	if tech_warTech and 0 < tech_warTech.currentLevel then
		ruins_tech_value_add = technologyCtrl:getTechnologyPower(gTechnologyType.RUINS_WAR_CARRY_SOLDIER_NUM_ADD, gPlayerBattleGround.RUINS) or 0
	end
	local constVal = constantRead.getConstValue("RUINS_WAR_ARMY_NUM", 3000000)
	self.allCount = constVal + ruins_buff_value_add + ruins_tech_value_add
	self.curCount = 0
	self.isSelectFull = false
	self.tableTeamData, _ENV, self.nameErr = gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL, gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL, gErrDef.Err_RUINS_WAR_TEAM_NAME_ILLEGAL
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_858"))
	self.btn_convene = SoraDGetChildByName(self, "Button_convene")
	self.btn_convene:setTitleText(i18n("common_text_3616"))
	self.btnQuickChoose = SoraDGetChildByName(self, "Button_quick")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelCountTotal = SoraDGetChildByName(self, "Text_countTotal")
	self.spriteCount = SoraDGetChildByName(self, "Sprite_count")
	self.labelTitle = SoraDGetChildByName(self, "Text_quick_title")
	self.labelTitle:setString(i18n("common_text_852"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_go")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnQuickChoose:addTouchEventListener(handler(self, self.btnQuickClickCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.btn_convene:addTouchEventListener(handler(self, self.btnConveneClickCallBack))
	self.nodeBg = SoraDGetChildByName(self, "Top_Node_bg")
	self.nodeCreate = SoraDGetChildByName(self, "Top_Node_create")
	self.nodeCreate:setVisible(false)
	self.nodeAdd = SoraDGetChildByName(self, "Top_Node_add")
	self.nodeAdd:setVisible(false)
	self.labelTeamName = SoraDGetChildByName(self, "Text_team_name")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelName:setString(i18n("remains_text_12"))
	self.spTeamFlag = SoraDGetChildByName(self, "Sprite_team_flag")
end
function teamDispatchArmyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_DISPATCH_BACK", handler(self, self.rspDispatchBack))
end
function teamDispatchArmyView:adaptTeam(compile)
	local noneCompile = true
	if next(compile) ~= nil then
		for _, v in pairs(compile) do
			if v.num > 0 then
				noneCompile = false
				break
			end
		end
	end
	if noneCompile then
		return
	end
	self:resetArmySelect()
	for _, v in pairs(compile) do
		if v.num > 0 then
			local armyid = tonumber(v.id)
			local data = self.tableArmyData[armyid]
			if data then
				self:setCurValByArmyid(armyid, v.num)
			end
		end
	end
	self:updateView()
end
function teamDispatchArmyView:initArmyData()
	if self.dispatchType == dispatchType.teamAdjust then
		self:initData()
		self:adaptTeam(self.tableTeamData.army)
	else
		self:initData()
		self:quickChoose(true)
	end
end
function teamDispatchArmyView:initCreateView()
	self.dispatchType = dispatchType.teamCreate
	self.nodeTitle:setTitle(i18n("remains_btn_02"))
	self.btnGo:setTitleText(i18n("remains_btn_04"))
	self:setTeamName(true)
	self:initArmyData()
end
function teamDispatchArmyView:initAddView(data)
