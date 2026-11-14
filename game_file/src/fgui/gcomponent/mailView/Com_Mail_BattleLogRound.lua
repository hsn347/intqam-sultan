local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_BattleLogRound = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_BattleLogRound", Com_Mail_BattleLogRound)
function Com_Mail_BattleLogRound:onInit()
end
function Com_Mail_BattleLogRound:onShow()
end
function Com_Mail_BattleLogRound:initData(value, isDefense, towerRoundData)
	dump(value, "Com_Mail_BattleLogRound:initData")
	local noMsg = i18n("common_text_480")
	local prepareTitle = i18n("battlelog_text_44")
	local myPrepareDesc = noMsg
	local enemyPrepareDesc = noMsg
	local detailTitle = i18n("battlelog_text_45")
	local myDetailDesc = noMsg
	local enemyDetailDesc = noMsg
	local finishTitle = i18n("battlelog_text_46")
	local myFinishDesc = noMsg
	local enemyFinishDesc = noMsg
	local isAttack = value[1] == 1
	local isMyAction = isDefense and not isAttack or not isDefense and isAttack
	local myName = i18n("battlelog_text_41")
	local enemyName = i18n("battlelog_text_40")
	local attackName, defendName
	if isDefense then
		attackName = enemyName
		defendName = myName
	else
		attackName = myName
		defendName = enemyName
	end
	local myColor = "#006E00"
	local enemyColor = "#D24B01"
	local color1, color2
	if isMyAction then
		color1 = myColor
		color2 = enemyColor
	else
		color1 = enemyColor
		color2 = myColor
	end
	local spColor = "#B45900"
	local dfColor = "#55230F"
	local _ENV, myPrepareStrList
	local _ENV, enemyPrepareStrList
	local _ENV, myDetailStrList
	local _ENV, enemyDetailStrList
	local _ENV, myFinishStrList
	local _ENV, enemyFinishStrList
	if value[5] then
		if value[5].roundEffectTimes and next(value[5].roundEffectTimes) then
			local _ENV, attackSkillList = next(value[5].roundEffectTimes), next(value[5].roundEffectTimes)
			local _ENV, defendSkillList = value[5].roundEffectTimes, value[5].roundEffectTimes
			if not value[5].roundEffectTimes.attack then
				local _ENV, attackData = value[5].roundEffectTimes.attack, value[5].roundEffectTimes.attack
			end
			for k, v in pairs(attackData) do
				local strTitle = include("mailFunctions"):getFightDetailSpecialEffectTitle(k, v, attackName, defendName, 2)
				if strTitle ~= nil then
					table.insert(attackSkillList, strTitle)
				end
			end
			if not value[5].roundEffectTimes.defend then
				local _ENV, defendData = value[5].roundEffectTimes.defend, value[5].roundEffectTimes.defend
			end
			for k, v in pairs(defendData) do
				local strTitle = include("mailFunctions"):getFightDetailSpecialEffectTitle(k, v, defendName, attackName, 2)
				if strTitle ~= nil then
					table.insert(defendSkillList, strTitle)
				end
			end
			if 0 < #attackSkillList then
				_ENV = attackSkillList
				attackSkillList.color = spColor
				local magicLampSkillStr = string.format("%s %s", i18n("war_report_text_0012"), SoraDWrapHtmlTagByStyle(table.concat(attackSkillList, ","), attackSkillList))
				if isDefense then
					table.insert(myPrepareStrList, magicLampSkillStr)
				else
					table.insert(enemyPrepareStrList, magicLampSkillStr)
				end
			end
			if 0 < #defendSkillList then
				_ENV = defendSkillList
				defendSkillList.color = spColor
				local magicLampSkillStr = string.format("%s %s", i18n("war_report_text_0012"), SoraDWrapHtmlTagByStyle(table.concat(defendSkillList, ","), defendSkillList))
				if not isDefense then
					table.insert(myPrepareStrList, magicLampSkillStr)
				else
					table.insert(enemyPrepareStrList, magicLampSkillStr)
				end
			end
		end
		if value[5].dmgRebound ~= nil and next(value[5].dmgRebound) ~= nil then
			_ENV = value[5].roundEffectTimes.attack
			_ENV, _ENV, value[5].roundEffectTimes.attack.num = math.floor(value[5].dmgRebound.reDamage)
			string.formatnumberthousands(math.floor(value[5].dmgRebound.reDamage)).num, math.floor(value[5].dmgRebound.reDamage).color = math.floor(value[5].dmgRebound.reDamage)
			local detailStr = i18n_html("battlelog_text_48", value[5].roundEffectTimes.attack, string.formatnumberthousands(math.floor(value[5].dmgRebound.reDamage)), true)
			if not isMyAction then
				table.insert(myDetailStrList, detailStr)
			else
				table.insert(enemyDetailStrList, detailStr)
			end
		end
		if value[5].defDmgReund ~= nil and next(value[5].defDmgReund) ~= nil then
			_ENV = enemyDetailStrList
			_ENV, _ENV, enemyDetailStrList.num = math.floor(value[5].defDmgReund.reDamage)
			string.formatnumberthousands(math.floor(value[5].defDmgReund.reDamage)).num, math.floor(value[5].defDmgReund.reDamage).color = math.floor(value[5].defDmgReund.reDamage)
			local detailStr = i18n_html("battlelog_text_48", enemyDetailStrList, string.formatnumberthousands(math.floor(value[5].defDmgReund.reDamage)), true)
			if isMyAction then
				table.insert(myDetailStrList, detailStr)
			else
				table.insert(enemyDetailStrList, detailStr)
			end
		end
		local siegeLoseLimit = value[5].siegeLoseLimit
		siegeLoseLimit = siegeLoseLimit and math.floor(siegeLoseLimit)
		if siegeLoseLimit ~= nil and 0 < siegeLoseLimit then
			_ENV = detailStr
			detailStr.name = isAttack and attackName or defendName
			_ENV, _ENV, detailStr.num = math.floor(value[5].siegeLoseLimit)
			_ENV, string.formatnumberthousands(math.floor(value[5].siegeLoseLimit)).name, math.floor(value[5].siegeLoseLimit).color = math.floor(value[5].siegeLoseLimit)
			string.formatnumberthousands(math.floor(value[5].siegeLoseLimit)).num, math.floor(value[5].siegeLoseLimit).color = math.floor(value[5].siegeLoseLimit)
			local detailStr = i18n_html("battlelog_text_49", detailStr, string.formatnumberthousands(math.floor(value[5].siegeLoseLimit)), true)
			if not isMyAction then
				table.insert(myDetailStrList, detailStr)
			else
				table.insert(enemyDetailStrList, detailStr)
			end
		end
		if value[5].shieldBearDamage and 0 < value[5].shieldBearDamage then
			_ENV = enemyDetailStrList
			_ENV, _ENV, enemyDetailStrList.num = math.floor(value[5].shieldBearDamage)
			string.formatnumberthousands(math.floor(value[5].shieldBearDamage)).num, math.floor(value[5].shieldBearDamage).color = math.floor(value[5].shieldBearDamage)
			local str = i18n_html("battlelog_text_50", enemyDetailStrList, string.formatnumberthousands(math.floor(value[5].shieldBearDamage)), true)
			if not isMyAction then
				table.insert(myDetailStrList, str)
			else
				table.insert(enemyDetailStrList, str)
			end
		end
		local actStr = ""
		if 0 < value[5].critTimes then
			if actStr == "" then
				actStr = i18n("war_report_text_0012") .. " "
			end
			_ENV = true
			;(true).num = value[5].critTimes
			_ENV, _ENV, (true).damage_type = "war_report_text_0020", i18n("war_report_text_0020"), i18n("war_report_text_0020")
			i18n("war_report_text_0020").damage_type, ("war_report_text_0020").color = "war_report_text_0020", spColor
			actStr = actStr .. i18n_html("war_report_text_0013", true, i18n("war_report_text_0020"), true) .. ","
		end
		if 0 < value[5].weaknessTimes then
			if actStr == "" then
				actStr = i18n("war_report_text_0012") .. " "
			end
			_ENV = true
			;(true).num = value[5].weaknessTimes
			_ENV, _ENV, (true).damage_type = "war_report_text_0021", i18n("war_report_text_0021"), i18n("war_report_text_0021")
			i18n("war_report_text_0021").damage_type, ("war_report_text_0021").color = "war_report_text_0021", spColor
			actStr = actStr .. i18n_html("war_report_text_0013", true, i18n("war_report_text_0021"), true) .. ","
		end
		if 0 < value[5].pierceTimes then
			if actStr == "" then
				actStr = i18n("war_report_text_0012") .. " "
			end
			_ENV = true
			;(true).num = value[5].pierceTimes
			_ENV, _ENV, (true).damage_type = "war_report_text_0022", i18n("war_report_text_0022"), i18n("war_report_text_0022")
			i18n("war_report_text_0022").damage_type, ("war_report_text_0022").color = "war_report_text_0022", spColor
			actStr = actStr .. i18n_html("war_report_text_0013", true, i18n("war_report_text_0022"), true) .. ","
		end
		_ENV = ","
		;(",").name1 = isAttack and attackName or defendName
		;(",").armyType = include("mailFunctions"):getArmyTypeName(value[5].armyType)
		;(",").name2 = isAttack and defendName or attackName
		;(",").num_1 = value[5].atkTimes
		;(",").damage = include("mailFunctions"):getAttackName(value[2])
		;(",").str = actStr
		_ENV, _ENV, (",").num_2 = math.floor(value[3])
		_ENV, string.formatnumberthousands(math.floor(value[3])).name1, math.floor(value[3]).color = math.floor(value[3])
		_ENV, string.formatnumberthousands(math.floor(value[3])).armyType, math.floor(value[3]).color = math.floor(value[3])
		_ENV, string.formatnumberthousands(math.floor(value[3])).name2, math.floor(value[3]).color = math.floor(value[3])
		_ENV, string.formatnumberthousands(math.floor(value[3])).damage, math.floor(value[3]).color = math.floor(value[3])
		string.formatnumberthousands(math.floor(value[3])).num_2, math.floor(value[3]).color = math.floor(value[3])
		local str = i18n_html("war_report_text_0011", ",", string.formatnumberthousands(math.floor(value[3])), true)
		if isMyAction then
			table.insert(myDetailStrList, str)
		else
			table.insert(enemyDetailStrList, str)
		end
		if value[5].addShield and 0 < value[5].addShield then
			_ENV = str
			_ENV, _ENV, str.num = math.floor(value[5].addShield)
			string.formatnumberthousands(math.floor(value[5].addShield)).num, math.floor(value[5].addShield).color = math.floor(value[5].addShield)
			local str = i18n_html("mail_2_text_105", str, string.formatnumberthousands(math.floor(value[5].addShield)), true)
			if isMyAction then
				table.insert(myDetailStrList, str)
			else
				table.insert(enemyDetailStrList, str)
			end
		end
		if 0 < value[5].strikeBackTimes or 0 < value[5].dodgeTimes then
			local detailStr
			local actStr = ""
			if 0 < value[5].dodgeTimes then
				_ENV = math.floor(value[5].addShield)
				math.floor(value[5].addShield).num = value[5].dodgeTimes
				_ENV, _ENV, math.floor(value[5].addShield).damage_type = "war_report_text_0019", i18n("war_report_text_0019"), i18n("war_report_text_0019")
				i18n("war_report_text_0019").damage_type, ("war_report_text_0019").color = "war_report_text_0019", spColor
				actStr = actStr .. i18n_html("war_report_text_0013", math.floor(value[5].addShield))
			end
			if 0 < value[5].strikeBackTimes then
				if actStr ~= "" then
					actStr = actStr .. ","
				end
				_ENV = math.floor(value[5].addShield)
				math.floor(value[5].addShield).num = value[5].strikeBackTimes
				_ENV, _ENV, math.floor(value[5].addShield).damage_type = "armyspeciality_name_1347", i18n("armyspeciality_name_1347"), i18n("armyspeciality_name_1347")
				i18n("armyspeciality_name_1347").damage_type, ("armyspeciality_name_1347").color = "armyspeciality_name_1347", spColor
				actStr = actStr .. i18n_html("war_report_text_0013", math.floor(value[5].addShield))
				_ENV = "war_report_text_0013"
				;("war_report_text_0013").name = isAttack and attackName or defendName
				;("war_report_text_0013").str = actStr
				_ENV, _ENV, ("war_report_text_0013").num = math.floor(value[5].strikeBackDmg)
				_ENV, string.formatnumberthousands(math.floor(value[5].strikeBackDmg)).name, math.floor(value[5].strikeBackDmg).color = math.floor(value[5].strikeBackDmg)
				string.formatnumberthousands(math.floor(value[5].strikeBackDmg)).num, math.floor(value[5].strikeBackDmg).color = math.floor(value[5].strikeBackDmg)
				detailStr = i18n_html("war_report_text_0015", "war_report_text_0013", string.formatnumberthousands(math.floor(value[5].strikeBackDmg)), true)
			else
				_ENV, _ENV = string.formatnumberthousands(math.floor(value[5].strikeBackDmg)), "war_report_text_0013"
				detailStr = i18n_html("war_report_text_0012", "war_report_text_0013", string.formatnumberthousands(math.floor(value[5].strikeBackDmg)), true) .. actStr
			end
			if not isMyAction then
				table.insert(myDetailStrList, detailStr)
			else
				table.insert(enemyDetailStrList, detailStr)
			end
		end
		if value[5].dodgeStrikebackTimes and 0 < value[5].dodgeStrikebackTimes and value[5].dodgeStrikebackDmg then
			_ENV = table.insert
			table.insert.name = isAttack and attackName or defendName
			_ENV, _ENV, table.insert.num = math.floor(value[5].dodgeStrikebackDmg)
			_ENV, string.formatnumberthousands(math.floor(value[5].dodgeStrikebackDmg)).name, math.floor(value[5].dodgeStrikebackDmg).color = math.floor(value[5].dodgeStrikebackDmg)
			string.formatnumberthousands(math.floor(value[5].dodgeStrikebackDmg)).num, math.floor(value[5].dodgeStrikebackDmg).color = math.floor(value[5].dodgeStrikebackDmg)
			local str = i18n_html("mail_2_text_106", table.insert, string.formatnumberthousands(math.floor(value[5].dodgeStrikebackDmg)), true)
			if not isMyAction then
				table.insert(myDetailStrList, str)
			else
				table.insert(enemyDetailStrList, str)
			end
		end
		if value[5].isDizziness ~= nil then
			_ENV, _ENV = str, enemyDetailStrList
			local str = i18n_html("battlelog_text_47", enemyDetailStrList, str, true)
			if value[5].isDizziness.atk then
				table.insert(myDetailStrList, str)
			end
			if value[5].isDizziness.def then
				table.insert(enemyDetailStrList, str)
			end
		end
		local atackIdx = isAttack and 2 or 1
		local totalLoseNum = (value[4] or 0) + (towerRoundData[atackIdx] or 0)
		if 0 < totalLoseNum then
			_ENV = true
			_ENV, (true).num = string.formatnumberthousands(totalLoseNum), string.formatnumberthousands(totalLoseNum)
			local loseNumStr = i18n_html("war_report_text_0016", true, string.formatnumberthousands(totalLoseNum), true)
			if not isMyAction then
				table.insert(myFinishStrList, loseNumStr)
			else
				table.insert(enemyFinishStrList, loseNumStr)
			end
		end
		local defendIdx = isAttack and 1 or 2
		local totoSelfLoseNum = (value[5].selfLoseTotalNum or 0) + (towerRoundData[defendIdx] or 0)
		if 0 < totoSelfLoseNum then
			_ENV = true
			_ENV, (true).num = string.formatnumberthousands(totoSelfLoseNum), string.formatnumberthousands(totoSelfLoseNum)
			local detailStr = i18n_html("war_report_text_0016", true, string.formatnumberthousands(totoSelfLoseNum), true)
			if isMyAction then
				table.insert(myFinishStrList, detailStr)
			else
				table.insert(enemyFinishStrList, detailStr)
			end
		end
		if towerRoundData[1] and towerRoundData[1] > 0 then
			_ENV = enemyFinishStrList
			_ENV, _ENV, enemyFinishStrList.num = towerRoundData[1], string.formatnumberthousands(towerRoundData[1]), string.formatnumberthousands(towerRoundData[1])
			string.formatnumberthousands(towerRoundData[1]).num, towerRoundData[1].color = towerRoundData[1], spColor
			local str = i18n_html("battlelog_text_64", enemyFinishStrList, string.formatnumberthousands(towerRoundData[1]), true)
			if isMyAction then
				table.insert(myFinishStrList, str)
			else
				table.insert(enemyFinishStrList, str)
			end
		elseif towerRoundData[2] and towerRoundData[2] > 0 then
			_ENV = enemyFinishStrList
			_ENV, _ENV, enemyFinishStrList.num = towerRoundData[2], string.formatnumberthousands(towerRoundData[2]), string.formatnumberthousands(towerRoundData[2])
			string.formatnumberthousands(towerRoundData[2]).num, towerRoundData[2].color = towerRoundData[2], spColor
			local str = i18n_html("battlelog_text_64", enemyFinishStrList, string.formatnumberthousands(towerRoundData[2]), true)
			if not isMyAction then
				table.insert(myFinishStrList, str)
			else
				table.insert(enemyFinishStrList, str)
			end
		end
		if value[5].loseArmyRate ~= nil then
			local num2 = value[5].loseArmyDmgPlus and value[5].loseArmyDmgPlus / 10 or 0
			_ENV = str
			str.name = isAttack and attackName or defendName
			str.num1 = string.formatnumberthousands(string.format("%.2f", value[5].loseArmyRate * 100))
			_ENV, _ENV, str.num2 = string.format("%.2f", value[5].loseArmyRate * 100)
			_ENV, string.formatnumberthousands(string.format("%.2f", value[5].loseArmyRate * 100)).name, string.format("%.2f", value[5].loseArmyRate * 100).color = string.format("%.2f", value[5].loseArmyRate * 100)
			_ENV, string.formatnumberthousands(string.format("%.2f", value[5].loseArmyRate * 100)).num1, string.format("%.2f", value[5].loseArmyRate * 100).color = string.format("%.2f", value[5].loseArmyRate * 100)
			string.formatnumberthousands(string.format("%.2f", value[5].loseArmyRate * 100)).num2, string.format("%.2f", value[5].loseArmyRate * 100).color = string.format("%.2f", value[5].loseArmyRate * 100)
			local detailStr = i18n_html("battlelog_text_51", str, string.formatnumberthousands(string.format("%.2f", value[5].loseArmyRate * 100)), true)
			if isMyAction then
				table.insert(myFinishStrList, detailStr)
			else
				table.insert(enemyFinishStrList, detailStr)
			end
		end
		if value[5].selfShieldBearDamage and 0 < value[5].selfShieldBearDamage then
			_ENV = table.insert
			_ENV, _ENV, table.insert.num = math.floor(value[5].selfShieldBearDamage)
			string.formatnumberthousands(math.floor(value[5].selfShieldBearDamage)).num, math.floor(value[5].selfShieldBearDamage).color = math.floor(value[5].selfShieldBearDamage)
			local str = i18n_html("battlelog_text_50", table.insert, string.formatnumberthousands(math.floor(value[5].selfShieldBearDamage)), true)
			if isMyAction then
				table.insert(myDetailStrList, str)
			else
				table.insert(enemyDetailStrList, str)
			end
		end
	end
	if 0 < #myPrepareStrList then
		myPrepareDesc = table.concat(myPrepareStrList, "\n")
	end
	if 0 < #enemyPrepareStrList then
		enemyPrepareDesc = table.concat(enemyPrepareStrList, "\n")
	end
	if 0 < #myDetailStrList then
		myDetailDesc = table.concat(myDetailStrList, "\n")
	end
	if 0 < #enemyDetailStrList then
		enemyDetailDesc = table.concat(enemyDetailStrList, "\n")
	end
	if 0 < #myFinishStrList then
		myFinishDesc = table.concat(myFinishStrList, "\n")
	end
	if 0 < #enemyFinishStrList then
		enemyFinishDesc = table.concat(enemyFinishStrList, "\n")
	end
	self.fields.Log_prepare:initData(prepareTitle, myPrepareDesc, enemyPrepareDesc)
	self.fields.Log_detail:initData(detailTitle, myDetailDesc, enemyDetailDesc)
	self.fields.Log_finish:initData(finishTitle, myFinishDesc, enemyFinishDesc)
	self.fields.layout:ensureBoundsCorrect()
end
return Com_Mail_BattleLogRound
