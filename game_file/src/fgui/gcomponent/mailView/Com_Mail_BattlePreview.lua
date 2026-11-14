local mailFunctions = include("mailFunctions")
local baseComponent = require("fgui.base.baseComponent")
local Com_Mail_BattlePreview = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_Mail_BattlePreview", Com_Mail_BattlePreview)
function Com_Mail_BattlePreview:onInit()
	self.fields.text_enemy:setString(i18n("battlelog_text_38"))
	self.fields.text_my:setString(i18n("battlelog_text_39"))
end
function Com_Mail_BattlePreview:initData(contentData, isDefense)
	local roundLiveNum = contentData.battleDetails.roundLiveNum
	local attackTotalNum, defenceTotalNum = mailFunctions:getTotalNumStr(contentData.playerInfo1.fightSummary, contentData.playerInfo2.fightSummary, true)
	attackTotalNum = attackTotalNum or 0
	defenceTotalNum = defenceTotalNum or 0
	local maxNum = math.max(attackTotalNum, defenceTotalNum) * 1.05
	local spaceNum = maxNum / 5
	for i = 1, 6 do
		self.fields["text_num" .. i]:setString(SoraDConvertNumberWithUnit(spaceNum * (i - 1)))
	end
	if not roundLiveNum then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.text_tips:setString(i18n("battlelog_text_67"))
		return
	end
	local showRound = table.nums(roundLiveNum)
	_ENV = roundLiveNum
	local _ENV, roundLiveNum[1], attackLastNums = attackTotalNum, attackTotalNum, roundLiveNum
	local attackTotalNum[1], defenceLastNums = defenceTotalNum, attackTotalNum
	local maxWidth = 520
	local maxHeight = 300
	mailFunctions = i18n("battlelog_text_67")
	mailFunctions, i18n("battlelog_text_67")[1] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[2] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[3] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[4] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[5] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[6] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[7] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[8] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[9] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[10] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[11] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[12] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[13] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	mailFunctions, i18n("battlelog_text_67")[14] = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	local mailFunctions, i18n("battlelog_text_67")[15], attackPoints = cc.p(0, maxHeight * (attackTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[1] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[2] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[3] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[4] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[5] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[6] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[7] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[8] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[9] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[10] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[11] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[12] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	cc.p(0, maxHeight * (attackTotalNum / maxNum))[13] = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	local cc.p(0, maxHeight * (attackTotalNum / maxNum))[14], defencePoints = cc.p(0, maxHeight * (defenceTotalNum / maxNum))
	for i = 0, showRound - 1 do
		local idx = tostring(i)
		local attackLastNum = roundLiveNum[idx] and roundLiveNum[idx][1] or 0
		local defenceLastNum = roundLiveNum[idx] and roundLiveNum[idx][2] or 0
		local pointX = maxWidth * (i + 1) / showRound
		local pointY = maxHeight * (attackLastNum / maxNum)
		table.insert(attackPoints, cc.p(pointX, pointY))
		pointY = maxHeight * (defenceLastNum / maxNum)
		table.insert(defencePoints, cc.p(pointX, pointY))
	end
	local drawParent = self.fields.Com_Mail_BattlePreviewDraw
	if not self.attackDrawNode then
		self.attackDrawNode = cc.DrawNode:create()
		self.attackDrawNode:setLineWidth(4)
		drawParent:addChild(self.attackDrawNode, 1)
	end
	local attackColor = not isDefense and cc.c4b(0, 110, 0, 255) or cc.c4b(210, 75, 1, 255)
	local defenceColor = not isDefense and cc.c4b(210, 75, 1, 255) or cc.c4b(0, 110, 0, 255)
	self.attackDrawNode:clear()
	for i = 2, #attackPoints do
		self.attackDrawNode:drawLine(attackPoints[i - 1], attackPoints[i], attackColor)
	end
	if not self.defenceDrawNode then
		self.defenceDrawNode = cc.DrawNode:create()
		self.defenceDrawNode:setLineWidth(4)
		drawParent:addChild(self.defenceDrawNode, 1)
	end
	self.defenceDrawNode:clear()
	for i = 2, #defencePoints do
		self.defenceDrawNode:drawLine(defencePoints[i - 1], defencePoints[i], defenceColor)
	end
end
function Com_Mail_BattlePreview:onShow()
end
return Com_Mail_BattlePreview
