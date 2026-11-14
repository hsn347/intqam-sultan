local baseComponent = require("fgui.base.baseComponent")
local Com_WHV_history = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWarHall/Com_WHV_history", Com_WHV_history)
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceBWList = gametop.playertop_:getModule("allianceBWList")
local allianceDesRead = include("allianceDesRead")
function Com_WHV_history:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.tableSingleData, _ENV = self.fixChildrenPos, self.fixChildrenPos
	self.fields.btnMine:setSwallowTouches(false)
	self.fields.btnEnemy:setSwallowTouches(false)
	self.fields.btnMine:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
	self.fields.btnEnemy:addEventListener(fgui.UIEventType.Click, handler(self, self.btnClickCallBack))
end
function Com_WHV_history:onShow()
end
function Com_WHV_history:getObjectName(data)
	if data.objId then
		local icon = allianceDesRead.getBuildIcon(data.objId)
		if data.objId and data.objId == gMapAllianceBuildType.subTypeAllianceFlag and data.flag then
			icon = allianceDesRead.getFlagIcon(data.flag)
		end
		return allianceDesRead.getBuildName(data.objId), icon
	else
		return data.nname
	end
end
function Com_WHV_history:getOwnAid()
	local ownaid
	if worldMapDefine.isInTeamStatus() then
		ownaid = allianceMgr:getOwnTeamID()
	else
		ownaid = allianceMgr:getOwnAid()
	end
	return ownaid
end
function Com_WHV_history:initData(historyData)
	self.tableSingleData = historyData
	local isWin = false
	local ownaid = self:getOwnAid()
	if self.tableSingleData.atk.teamId then
		self.tableSingleData.atk.aid = self.tableSingleData.atk.teamId
	end
	if self.tableSingleData.def.teamId then
		self.tableSingleData.def.aid = self.tableSingleData.def.teamId
	end
	local ownuid = self.tableSingleData.atk.aid == ownaid and self.tableSingleData.atk.uid or self.tableSingleData.def.uid
	if ownuid == self.tableSingleData.winner then
		isWin = true
	end
	local mineData = self.tableSingleData.atk
	if self.tableSingleData.def.aid == ownaid then
		mineData = self.tableSingleData.def
	end
	self.mineData = mineData
	local enemyData = self.tableSingleData.atk
	if self.tableSingleData.def.aid ~= ownaid then
		enemyData = self.tableSingleData.def
	end
	self.enemyData = enemyData
	local isAttack = false
	local typeScale = 0.6
	if self.tableSingleData.atk.uid == ownuid then
		isAttack = true
		typeScale = 0.8
	end
	local kid = lordInfoCtrl:getLordInfo().base.partition
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	local ownKid = sourceKid == 0 and kid or sourceKid
	local stateIcon = isAttack and "icon_fight_attack.png" or "icon_alliancewar_defender.png"
	local enemyIcon = isAttack and "icon_alliancewar_defender.png" or "icon_fight_attack.png"
	local stateFlag = isWin and "frame_flag_record_02.png" or "frame_flag_record_01.png"
	local strResult = isWin and i18n("common_text_290") or i18n("common_text_291")
	local colorResult = isWin and cc.c3b(255, 255, 0) or cc.c3b(120, 120, 120)
	local mineName, mineHeadIcon = self:getObjectName(mineData)
	local enemyName, enemyHeadIcon = self:getObjectName(enemyData)
	local mine_abbr = self.fields.mine_abbr
	local mine_name = self.fields.mine_name
	local mine_head = self.fields.mine_head
	local mine_state = self.fields.mine_state
	local mine_bwicon = self.fields.mine_bwicon
	mine_state:setVisible(false)
	local enemy_abbr = self.fields.enemy_abbr
	local enemy_name = self.fields.enemy_name
	local enemy_head = self.fields.enemy_head
	local enemy_state = self.fields.enemy_state
	local enemy_bwicon = self.fields.enemy_bwicon
	enemy_state:setVisible(false)
	self.controllers.c1:setSelectedIndex(isWin and 0 or 1)
	self.fields.iconFightType:setURL(stateIcon)
	self.fields.iconFightType:setScale(typeScale)
	self.fields.labelResult:setString(strResult)
	self:updateBWBtn(mineData.aid, mine_bwicon)
	self:updateBWBtn(enemyData.aid, enemy_bwicon)
	if mineData.abbr then
		mine_abbr:setString("(" .. mineData.abbr .. ")")
	else
		mine_abbr:setString("")
	end
	if mineHeadIcon then
		mine_head:setImage(mineHeadIcon, false)
	else
		mine_head:setHeadSprite(mine_head, mineData.iconID, mineData.avatar)
	end
	if enemyData.abbr then
		enemy_abbr:setString("(" .. enemyData.abbr .. ")")
	else
		enemy_abbr:setString("")
	end
	if enemyHeadIcon then
		enemy_head:setImage(enemyHeadIcon, false)
	else
		mine_head:setHeadSprite(enemy_head, enemyData.iconID, enemyData.avatar)
	end
	local teamStatus = worldMapDefine.isInTeamStatus()
	if ownKid ~= self.tableSingleData.atk.sourcekid then
		mine_name:setColor(display.COLOR_RED)
		if not teamStatus then
			lordInfoCtrl = display.COLOR_RED
			display.COLOR_RED.kid = mineData.sourcekid
			mineName = i18n("common_text_342", display.COLOR_RED) .. "\n" .. mineName
		end
	else
		mine_name:setColor(cc.c3b(240, 230, 210))
	end
	if ownKid ~= self.tableSingleData.def.sourcekid then
		enemy_name:setColor(display.COLOR_RED)
		if not teamStatus then
			lordInfoCtrl = display.COLOR_RED
			display.COLOR_RED.kid = enemyData.sourcekid
			enemyName = i18n("common_text_342", display.COLOR_RED) .. "\n" .. enemyName
		end
	else
		enemy_name:setColor(cc.c3b(240, 230, 210))
	end
	mine_name:setString(mineName)
	enemy_name:setString(enemyName)
	self.fields.labelTime:setString(SoraDConverSecondToDate(serviceFunctions.systemTime() - self.tableSingleData.time, false, true))
end
function Com_WHV_history:updateBWBtn(aid, node)
	if aid then
		local bwType = allianceBWList:isInBWList(aid)
		node:setVisible(bwType ~= nil)
		node:setURL(bwType == gAllianceBWListType.BLACK and "icon_alliance_blacklist.png" or "icon_alliance_whitelist.png")
	else
		node:setVisible(false)
	end
end
function Com_WHV_history:setScroll(scroll)
	self.scroll = scroll
end
function Com_WHV_history:btnClickCallBack(button, type)
	SoraDPlaySound()
	local curPlayer = self.enemyData
	if button == self.fields.btnMine then
		curPlayer = self.mineData
	end
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local kid = lordInfoCtrl:getLordInfo().base.partition
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	local ownKid = sourceKid == 0 and kid or sourceKid
	if curPlayer.objId and curPlayer.aid and curPlayer.sourcekid == ownKid then
		local proxy = uiManager:getProxy("AllianceWarHistory")
		if proxy and proxy.view then
			SoraDShowLoading(proxy.view:displayObject())
		end
		_ENV = proxy.view:displayObject()
		_ENV, proxy.view:displayObject().aid = curPlayer.aid, curPlayer.aid
		curPlayer.aid.from = "allianceWarHistory"
		allianceQuery:reqAllianceByID(proxy.view:displayObject())
	elseif lordInfoCtrl:getLordInfo().base.uid ~= curPlayer.uid then
		local chatConst = include("chatConst")
		_UPVALUE3_ = "chatConst"
		;("chatConst")[1] = chatConst.OpId.OpSendEmail
		;("chatConst")[2] = chatConst.OpId.OpViewInfo
		local ("chatConst")[3], menuData = chatConst.OpId.OpShield, "chatConst"
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel >= CASTLE_LV10_LIMITED then
			table.insert(menuData, chatConst.OpId.OpSendFlower)
		end
		_ENV = proxy.view:displayObject()
		proxy.view:displayObject().playerId = curPlayer.uid
		proxy.view:displayObject().nickName = curPlayer.nname
		proxy.view:displayObject().allianceAbbr = curPlayer.abbr
		proxy.view:displayObject().kid = curPlayer.sourcekid
		SoraDShowPlayerOperatePanel(curPlayer.nname, menuData, proxy.view:displayObject())
	else
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	end
end
return Com_WHV_history
