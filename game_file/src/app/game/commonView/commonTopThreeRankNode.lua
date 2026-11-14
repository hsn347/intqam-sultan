local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local commonTopThreeRankNode = class("commonTopThreeRankNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("commonTopThreeRankNode")
end)
_ENV = "commonTopThreeRankNode"
;("commonTopThreeRankNode").player = 1
;("commonTopThreeRankNode").alliance = 2
local ("commonTopThreeRankNode").kindom, rankType = 3, "commonTopThreeRankNode"
function commonTopThreeRankNode:ctor(properties)
	self.rankType = 0
	self.rankList = SoraDGetChildsArrayByName(self, "Node_rank_", 3, 1)
	self:initEffect()
end
function commonTopThreeRankNode:initEffect()
	local loop = false
	local cssFileName = "commonTopThreeRankNode"
	local cssFilePath = getCCSPath(cssFileName)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
	self.action:gotoFrameAndPause(40)
	local effectOne = SoraDCreatAnimation("rank_one", nil, true)
	effectOne:setPosition(cc.p(-7, 3))
	self.rankList[1]:addChild(effectOne)
	local effectTwo = SoraDCreatAnimation("rank_two", nil, true)
	effectTwo:setPosition(cc.p(0, 88))
	self.rankList[2]:addChild(effectTwo)
	local effectThree = SoraDCreatAnimation("rank_three", nil, true)
	effectThree:setPosition(cc.p(-2, 90))
	self.rankList[3]:addChild(effectThree)
end
function commonTopThreeRankNode:runTopAction()
	self.action:gotoFrameAndPlay(0, false)
end
function commonTopThreeRankNode:onMessageListener()
end
function commonTopThreeRankNode:initData(data, otherData)
	if otherData then
		self.parentView = otherData.view
		self.rankType = otherData.rankType
	end
	dump(data, "data")
	for i, target in ipairs(self.rankList) do
		local imageHead = SoraDGetChildByName(target, "Image_head")
		local nodeFlag = SoraDGetChildByName(target, "Node_flag")
		local btnJump = SoraDGetChildByName(target, "Button_Jump")
		btnJump:addTouchEventListener(handlerEx(self, self.btnJumpClick, data[i]))
		btnJump:setTouchEnabled(self.rankType == rankType.player)
		nodeFlag:setScale(i == 1 and 0.7 or 0.5)
		imageHead:setContentSize(i == 1 and cc.size(120, 120) or cc.size(100, 100))
		local textName = SoraDGetChildByName(target, "Text_name")
		local textScore = SoraDGetChildByName(target, "Text_score")
		if data[i] then
			if data[i].kingdomName then
				textName:setString(serviceFunctions.getKingdomFormatName(data[i].kingdomName, data[i].kid))
			else
				textName:setString(textParser.formatPlayerName(data[i].allianceAbbr, data[i].nickName, data[i].kid or data.kid))
			end
			if data[i].flag then
				nodeFlag:setVisible(true)
				imageHead:setVisible(false)
				allianceDesRead.getFlagWithParticle(data[i].flag, nodeFlag)
			elseif data[i].headid then
				imageHead:setVisible(true)
				SoraDGetHeadFromManager(imageHead, data[i].headid, data[i].avatar)
			end
			textScore:setString(i18n(self.scoreTitle or "common_text_1764") .. ":" .. string.formatnumberthousands(data[i].score))
		else
			imageHead:setContentSize(cc.size(68, 86))
			nodeFlag:setVisible(false)
			imageHead:setVisible(true)
			imageHead:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
			textScore:setString(i18n("common_text_480"))
			textName:setString("")
		end
	end
end
function commonTopThreeRankNode:setScoreTitle(str)
	self.scoreTitle = str
end
function commonTopThreeRankNode:btnJumpClick(data, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rankType == rankType.player then
			_ENV = lordInfoCtrl
			lordInfoCtrl.targetName = self.parentView.__cname
			lordInfoCtrl:getLordInfoByUid(data.uid, data.kid or lordInfoCtrl:getMapSourceKid(), lordInfoCtrl)
		end
	end
end
return commonTopThreeRankNode
