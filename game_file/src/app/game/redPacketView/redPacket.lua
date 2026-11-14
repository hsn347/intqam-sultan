local gametop = gModuleMgr.getObject("gametop")
local lordLocalData = include("lordLocalData")
local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
local chatFunctions = include("chatFunctions")
local redPacket = class("redPacket", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("redPacket")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function redPacket:ctor()
	self.btnCoin = SoraDGetChildByName(self, "btn_coin")
	if self.btnCoin then
		self.btnCoin:setPressedActionEnabled(true)
		self.btnCoin:addTouchEventListener(handler(self, self.onBtnCoin))
	end
	self.btn_look = SoraDGetChildByName(self, "btn_look")
	if self.btn_look then
		self.btn_look:addTouchEventListener(handler(self, self.onBtnLook))
	end
	self.center_ndoe = SoraDGetChildByName(self, "Center_node")
	self.text_player = SoraDGetChildByName(self, "text_player")
	self.text_look = SoraDGetChildByName(self, "text_look")
	self.img_player = SoraDGetChildByName(self, "img_player")
	self.img_bg = SoraDGetChildByName(self, "img_bg")
	self.avatarNode = SoraDGetChildByName(self, "avatar")
	self.text_player:setString("name")
	self.text_look:setString(i18n("common_text_1782"))
	self:addEffect()
	self.touchActionPanel = self.center_ndoe
end
function redPacket:addEffect()
	local particleFile1 = "Particle/et_hongbao_guang.plist"
	local particelFile2 = "Particle/et_hongbao_light.plist"
	self.effect1 = cc.ParticleSystemQuad:create(particleFile1)
	self.effect1:setPosition(cc.p(-5, 150))
	self.effect1:setPositionType(cc.POSITION_TYPE_RELATIVE)
	self.effect1:setAutoRemoveOnFinish(false)
	self.effect1:addTo(self.center_ndoe)
	self.effect1:setLocalZOrder(-2)
	self.effect1:setScale(2.0)
	self.effect2 = cc.ParticleSystemQuad:create(particelFile2)
	self.effect2:setPosition(cc.p(0, 200))
	self.effect2:setPositionType(cc.POSITION_TYPE_RELATIVE)
	self.effect2:setAutoRemoveOnFinish(false)
	self.effect2:addTo(self.center_ndoe)
	self.effect2:setLocalZOrder(-1)
	local scaleTo = cca.scaleTo(0.8, 1.04)
	local scaleBack = cca.scaleTo(0.8, 1.0)
	_UPVALUE2_ = 1.0
	;(1.0)[1] = scaleTo
	;(1.0)[2] = scaleBack
	local seq = cca.seq(1.0)
	local repeatAct = cca.repeatForever(seq)
	self.btnCoin:runAction(repeatAct)
end
function redPacket:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CHAT_SERVER_CLAIM_RED_PACKET", handler(self, self.sMsgClaimRedPacket))
end
function redPacket:initWithData(data, message)
	self.itemData = data
	self.message = message
	if not self.itemData then
		return
	end
	dump(data, "redPacket:initWithData(data)红包数据", 10)
	local iconID = self.itemData.iconid
	local avatar = self.itemData.avatar
	local defaultStr = i18n("common_text_1863")
	SoraDGetHeadFromManager(self.img_player, iconID, avatar)
	if message ~= nil then
		if not self.chatHeadNode then
			self.chatHeadNode = include("chatHeadNode").new()
			self.chatHeadNode:addTo(self.center_ndoe)
			self.chatHeadNode:init(self.message)
			self.chatHeadNode:setContentSize(cc.size(self.chatHeadNode.width, self.chatHeadNode.height))
			self.chatHeadNode:setAnchorPoint(cc.p(0.5, 0.5))
			local posAvatar = cc.p(self.avatarNode:getPosition())
			self.chatHeadNode:setPosition(cc.p(posAvatar.x, posAvatar.y + 15))
			self.avatarNode:setVisible(false)
		else
			self.chatHeadNode:init(self.message)
		end
	end
	local mailFunctions = include("mailFunctions")
	local name = self.itemData.nickname
	if self.itemData.type == 2 then
		name = mailFunctions:getWrappedName(self.itemData.allianceAbbr, self.itemData.nickname)
	end
	if self.itemData.npcId then
		name = chatFunctions:getNpcName(self.itemData.npcId)
	end
	name = string.format([[
%s
%s]], name, defaultStr or "")
	self.text_player:setString(name)
	if self.itemData.redEnvelopesType == gRedEnvelopesType.RECHARGE_GOLD_GIFT then
		self.img_bg:setSpriteFrame("icon_recharge_wallet.png")
	end
	if self.itemData.redEnvelopesType == gRedEnvelopesType.ICE_CRAZY_ACTIVITY then
		self.img_bg:setSpriteFrame("Icesnow_gift_background_map.png")
	end
	if self.itemData.redEnvelopesType == gRedEnvelopesType.ANNIVERSARY_2022_ACTIVITY then
		self.img_bg:setSpriteFrame("Icesnow_gift_background_map.png")
	end
end
function redPacket:onEnterPanel()
	self.center_ndoe:setScale(0.8)
	local actScale1 = cca.scaleTo(0.2, 1.15)
	local actScale2 = cca.scaleTo(0.1, 1.0)
	local actScale3 = cca.scaleTo(0.1, 1.02)
	local actScale4 = cca.scaleTo(0.1, 1.0)
	_UPVALUE4_ = 1.0
	;(1.0)[1] = actScale1
	;(1.0)[2] = actScale2
	;(1.0)[3] = actScale3
	;(1.0)[4] = actScale4
	local seq = cca.seq(1.0)
	self.center_ndoe:runAction(seq)
end
function redPacket:onBtnCoin(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rid = self.itemData.RID
		print("TODO: 发起抢红包请求------", rid)
		SoraDShowLoading()
		local chatFunctions = include("chatFunctions")
		local gametop = gModuleMgr.getObject("gametop")
		local redenvelopesCtrl = gametop.playertop_:getModule("redenvelopesCtrl")
		local playerId = chatFunctions:getSelfId()
		redenvelopesCtrl:sendGet(playerId, rid)
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.began then
	end
end
function redPacket:onBtnLook(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local rid = self.itemData.RID
		local uid = self.itemData.uid
		print("TODO：申请打开详情界面-------uid = ", uid, ",  rid = ", rid)
		SoraDShowLoading()
		local gametop = gModuleMgr.getObject("gametop")
		local redenvelopesCtrl = gametop.playertop_:getModule("redenvelopesCtrl")
		redenvelopesCtrl:sendCheck(uid, rid)
		chatRedPacketMgr:setIsReqViewRedPacket(true)
		self:close(nil, ccui.TouchEventType.ended)
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.began then
	end
end
function redPacket:sMsgClaimRedPacket(target, data)
	self:close(nil, ccui.TouchEventType.ended)
end
return redPacket
