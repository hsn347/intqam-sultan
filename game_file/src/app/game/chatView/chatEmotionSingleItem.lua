local sizeItem = cc.size(124, 94)
local imgSize = cc.size(94, 94)
local chatDesRead = include("chatDesRead")
local chatEmotionSingleItem = class("chatEmotionSingleItem", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("chatEmotionSingleItem"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function chatEmotionSingleItem:ctor()
	self:setSwallowTouches(false)
	self.img = SoraDGetChildByName(self, "Img")
	self.imgBg = SoraDGetChildByName(self, "ImgBg")
	self:setContentSize(sizeItem)
	if self.img then
		self.img:setSwallowTouches(false)
		self.img:addTouchEventListener(handler(self, self.onBtnImg))
	end
	self.img:setPosition(cc.p(sizeItem.width / 2, sizeItem.height / 2))
	self.imgBg:setPosition(cc.p(sizeItem.width / 2, sizeItem.height / 2))
	self.sprite = display.newSprite()
	self.sprite:setPosition(cc.p(sizeItem.width / 2, sizeItem.height / 2))
	self.img:addChild(self.sprite, 1)
	self.imgBg:setVisible(false)
	self.singleIsMoved = false
end
function chatEmotionSingleItem:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.msgKeyDownLoadSuccess))
end
function chatEmotionSingleItem:msgKeyDownLoadSuccess(target, data)
	local key = data.key
	if key == self.data.reskey then
		self:updateEmoticon()
	end
end
function chatEmotionSingleItem:setChatDelegate(chatDelegate)
	self.chatDelegate = chatDelegate
end
function chatEmotionSingleItem:updateEmoticon()
	local packageid = self.data.packageid
	local packagecfg = chatDesRead.getEmotionListCfg(packageid)
	self.img:setPressedActionEnabled(true)
	self.img:setContentSize(cc.size(imgSize.width, imgSize.width / self.img:getContentSize().width * self.img:getContentSize().height))
	self.img:ignoreContentAdaptWithSize(false)
	if packagecfg.emoticontype == gChatEmoticonType.normal then
		if self.imgName == nil then
			return
		end
		self.sprite:setVisible(false)
		self.sprite:stopAllActions()
		self.img:loadTextures(self.imgName, self.imgName, self.imgName, ccui.TextureResType.plistType)
	elseif packagecfg.emoticontype == gChatEmoticonType.animation then
		self.img:loadTextures("chat_icon_img_loading.png", "chat_icon_img_loading.png", "chat_icon_img_loading.png", ccui.TextureResType.plistType)
		local reskey = self.data.reskey
		if SoraDIsFileExistByKey(reskey) then
			chatDesRead, _ENV = reskey, SoraDIsFileExistByKey(reskey)
			reskey.name = string.format("Common/%s", reskey)
			local SoraDIsFileExistByKey(reskey)[1], imgArray = reskey, SoraDIsFileExistByKey(reskey)
			self:loadImages(imgArray, function()
				if not self.data or not self.sprite then
					return
				end
				local imgformat = self.data.imgformat
				local firstImg = string.format(imgformat, self.data.astart)
				if firstImg and firstImg ~= "" then
					self.sprite:setSpriteFrame(firstImg)
				end
				self.img:loadTextures("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
				local frames = display.newFrames(imgformat, self.data.astart, self.data.aend - self.data.astart + 1)
				local animation = display.newAnimation(frames, 0.16666666666666666)
				self.sprite:setVisible(true)
				self.sprite:stopAllActions()
				local delay = 0
				self:playAnimationForever(self.sprite, animation, delay)
			end)
		end
	end
end
function chatEmotionSingleItem:initWithData(param, otheData)
	local data, chatDelegate
	data = param.data
	chatDelegate = param.chatDelegate
	if otheData.scroll then
		self.scroll = otheData.scroll
	end
	local imgId = data.id
	self.data = data
	self.imgId = imgId
	self.imgName = data.img
	if data.imgEn and data.imgEn ~= "" and GameLanguageCopy ~= "ar" then
		self.imgName = data.imgEn
	end
	self.chatDelegate = chatDelegate
	self:updateEmoticon()
end
function chatEmotionSingleItem:playAnimationForever(target, animation, delay)
	if animation == nil then
		return
	end
	local animate = cc.Animate:create(animation)
	local action
	if type(delay) == "number" and 0 < delay then
		_UPVALUE3_ = delay
		delay[1] = cc.DelayTime:create(delay)
		delay[2] = cc.Show:create()
		delay[3] = animate
		local sequence = transition.sequence(delay)
		action = cc.RepeatForever:create(sequence)
	else
		action = cc.RepeatForever:create(animate)
	end
	target:runAction(action)
	return action
end
function chatEmotionSingleItem:onBtnImg(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local contenttext = self.imgId
		print("发送了：" .. contenttext)
		if self.chatDelegate then
			local packageid = self.data.packageid
			local chatDesRead = include("chatDesRead")
			local packageCfg = chatDesRead.getEmotionListCfg(packageid)
			_ENV = packageid
			packageid.message = contenttext
			packageid.messageType = gChatTypeDef.chat_content_expression
			packageid.packetId = packageCfg.packagename
			packageid.grupid = self.data.packageid
			local packageid.id, param = self.data.id, packageid
			self.chatDelegate:chatSendOneMessage(self, param)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return chatEmotionSingleItem
