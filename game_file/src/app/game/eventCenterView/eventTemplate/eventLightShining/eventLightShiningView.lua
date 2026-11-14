local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local unityShaderConfig = include("unityShaderConfig")
local COLOR_GRAY = cc.c4f(0.05, 0.05, 0.05, 0.5)
local COLOR_HIGHT = cc.c4f(0.98, 0.88, 0.88, 1.0)
local eventLightShiningView = class("eventLightShiningView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventLightShiningView")
	end
	return target
end)
function eventLightShiningView:ctor()
	self.buffItemArray, _ENV, self.lineArray, _ENV, self.baseLineArray, _ENV, self.activityID = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY, gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY
	self.isActed = false
	self.unity_offsetY = 1.9
	self.unity_scaleY = 0.62
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("activity_name_9001263"))
	self.ccs_title:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Image_sheer = SoraDGetChildByName(self, "Image_sheer")
	self.Bottom_Image_bg = SoraDGetChildByName(self, "Bottom_Image_bg")
	self.Text_quest = SoraDGetChildByName(self, "Text_quest")
	self.Text_quest:setString(i18n("common_text_675"))
	self.Button_quest = SoraDGetChildByName(self, "Button_quest")
	self.Button_quest = include("commonBtnInstance").new(self.Button_quest)
	self.Button_quest:setHandle(handler(self, self.onQuestTouchClick))
	self.Image_redPoint = SoraDGetChildByName(self, "Image_redPoint")
	self.Text_redPointInt = SoraDGetChildByName(self, "Text_redPointInt")
	self.Image_redPoint:setVisible(false)
	self.Top_nodeLight = SoraDGetChildByName(self, "Top_nodeLight")
	self.flowerArray = SoraDGetChildsArrayByName(self, "CCS_eventLightShiningSingle_", 4, 1, true, true)
	for i = 1, #self.flowerArray - 1 do
		local baseLine = self:drawBaseLine(self.flowerArray[i], self.flowerArray[i + 1])
		baseLine:addTo(self.Top_nodeLight, -2)
		self.baseLineArray[i] = baseLine
		local line = self:drawLine(self.flowerArray[i], self.flowerArray[i + 1], i)
		line:addTo(self.Top_nodeLight, -1)
		self.lineArray[i] = line
	end
	self.Node_buff = SoraDGetChildByName(self, "Node_buff")
	self.Button_light = SoraDGetChildByName(self, "Button_light")
	self.Button_light:setBright(false)
	self.Text_light = SoraDGetChildByName(self, "Text_light")
	self.Text_light:setString(i18n("Shine_text_05"))
	self.Button_light:addTouchEventListener(handler(self, self.onLightClick))
	self.Node_btnEffect = SoraDGetChildByName(self.Button_light, "Node_btnEffect")
	self.Node_btnEffect:setVisible(false)
	self.Node_aniTop = SoraDGetChildByName(self, "Node_aniTop")
	self.Node_effectActive = SoraDGetChildByName(self, "Node_effectActive")
	self.Node_effectActive:setVisible(false)
	self.Node_effectActived = SoraDGetChildByName(self, "Node_effectActived")
	self.Node_effectActived:setVisible(false)
	self:suitView()
	self:setTime()
	self:initData()
	SoraDTestButton(self, function()
		self:showLightBtnAct()
	end)
end
function eventLightShiningView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventLightShiningView:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventLightShiningView:suitView()
	if display.height >= 1206 then
		self.Bottom_Image_bg:loadTexture("bg_ghzy_bjt.png", ccui.TextureResType.plistType)
		self.Bottom_Image_bg:setContentSize(cc.size(640 * (display.height - 70) / 1136, display.height - 70))
		self.Top_nodeLight:setPositionY(display.height - 561)
		self.unity_scaleY = 0.71
		self.unity_offsetY = 0.75
	elseif display.height >= 1076 and display.height < 1206 then
		self.Bottom_Image_bg:loadTexture("bg_ghzy_bjt.png", ccui.TextureResType.plistType)
		self.Bottom_Image_bg:setContentSize(cc.size(640, 1136))
		self.Top_nodeLight:setPositionY(645)
	elseif display.height < 1076 then
		self.Bottom_Image_bg:loadTexture("bg_ghzy_bjt2.png", ccui.TextureResType.plistType)
		local realH = math.max(800, display.height - 70)
		self.Bottom_Image_bg:setContentSize(cc.size(640 * realH / 800, realH))
		self.Top_nodeLight:setPositionY(445)
		self.unity_offsetY = 1.18
	end
	self.Node_aniTop:setPositionY(math.max(-700, 500 - display.height))
	self:initEffect()
	self:initUnityEffect()
end
function eventLightShiningView:runFadeInAct()
	if self.isActed then
		return
	end
	self.isActed = true
	local fadeTime = 1.0
	_UPVALUE1_ = nil
	local _UPVALUE4_, (nil)[1], targetArray = self.Button_light, self.Button_light, nil
	self.Button_light[1] = "frame_ghzy_hmxh_r2"
	self.Button_light[2] = "frame_ghzy_qmxh_r1"
	self.Button_light[3] = "frame_ghzy_hmxh_l2"
	local self.Button_light[4], targetName = "frame_ghzy_qmxh_l1", self.Button_light
	for k, v in ipairs(targetName) do
		table.insert(targetArray, SoraDGetChildByName(self, v))
	end
	for k, v in pairs(self.buffItemArray) do
		v:runFadeInAct(fadeTime)
	end
	for k, v in ipairs(targetArray) do
		v:setOpacity(0)
		v:runAction(cca.fadeIn(fadeTime))
	end
end
function eventLightShiningView:initUnityEffect()
	local Node_unity = SoraDGetChildByName(self, "Bottom_Node_unity")
	local renderTexture = cc.RenderTexture:create(display.size.width, display.size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
	renderTexture:addTo(Node_unity)
	renderTexture:setAnchorPoint(cc.p(0.5, 0))
	renderTexture:setPosition(cc.p(0, 0))
	renderTexture:beginWithClear(0, 0, 0, 0)
	self.Bottom_Image_bg:visit()
	renderTexture:endToLua()
	renderTexture:setVisible(false)
	local niuqu2Shader = require("app.game.eventCenterView.shader.f_water_shader")
	local _ENV, niuqu2MeshParam = "app.game.eventCenterView.shader.f_water_shader", "app.game.eventCenterView.shader.f_water_shader"
	local niuqu2MeshData = require("app.game.eventCenterView.meshData.f_water_meshData")
	for i, v in ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param) do
		table.insert(niuqu2MeshParam, v)
	end
	_ENV = ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param)
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).attr = "vec4"
	_ENV, ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).name = cc.p(0, 0)
	cc.p(0, 0).x = 1
	cc.p(0, 0).y = self.unity_offsetY
	cc.p(0, 0).z = 0
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).value, cc.p(0, 0).w = cc.p(0, 0)
	table.insert(niuqu2MeshParam, ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param))
	_ENV = ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param)
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).attr = "#texture"
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).name = "_GrabTexture"
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).value = renderTexture:getSprite():getTexture()
	ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param).hasMipmap = false
	table.insert(niuqu2MeshParam, ipairs(require("app.game.eventCenterView.shaderCfg.f_water_shaderCfg").param))
	_ENV = table.insert
	table.insert.size = cc.size(1, 1)
	_ENV, table.insert.meshData = cc.size(1, 1), niuqu2MeshData
	cc.size(1, 1).vertBytes = niuqu2Shader.vertBytes
	table.insert.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), niuqu2Shader.fragBytes
	table.insert.param = niuqu2MeshParam
	_ENV, table.insert.pos = cc.p(0, self.Bottom_Image_bg:getContentSize().height / 2), cc.p(0, self.Bottom_Image_bg:getContentSize().height / 2)
	cc.p(0, self.Bottom_Image_bg:getContentSize().height / 2).x = 0.33
	table.insert.scale, cc.p(0, self.Bottom_Image_bg:getContentSize().height / 2).y = cc.p(0, self.Bottom_Image_bg:getContentSize().height / 2), self.unity_scaleY
	local niuqu2Data = table.insert
	local bottomWater = SoraDCreateMeshNode(niuqu2Data.meshData, niuqu2Data.size, niuqu2Data.shader, niuqu2Data.param)
	bottomWater:setPosition(cc.p(niuqu2Data.pos))
	bottomWater:setScale(niuqu2Data.scale.x, niuqu2Data.scale.y)
	bottomWater:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	bottomWater:addTo(Node_unity, 1)
	self.Bottom_Image_bg:setVisible(false)
end
function eventLightShiningView:initEffect()
	local et_aniTop = SoraDCreatAnimation("animationLSTop")
	et_aniTop:addTo(self.Node_aniTop)
	self.et_active = SoraDCreatAnimationEx("animationLSActive", nil, false)
	self.et_active:addTo(self.Node_effectActive)
	local et_aniLSBtn = SoraDCreatAnimation("animationLSBtn")
	et_aniLSBtn:addTo(self.Node_btnEffect)
end
function eventLightShiningView:showLightBtnAct()
	local starNum = lightShiningCtrl:getStarPoint()
	if starNum >= #self.flowerArray then
		_UPVALUE2_ = nil
		;(nil)[1] = cca.callFunc(function()
			for k, v in ipairs(self.flowerArray) do
				v:playAllEffect()
			end
			if self.et_active then
				_ENV, _ENV = ipairs(self.flowerArray)
				ipairs(self.flowerArray).scaleX = 1.2906
				_ENV, self.et_active.Sprite_1_0_0, ipairs(self.flowerArray).scaleY = ipairs(self.flowerArray)
				ipairs(self.flowerArray).scaleX = 2.1439
				_ENV, self.et_active.Sprite_1_0, ipairs(self.flowerArray).scaleY = ipairs(self.flowerArray)
				ipairs(self.flowerArray).scaleX = 2
				self.et_active.Sprite_1, ipairs(self.flowerArray).scaleY = ipairs(self.flowerArray)
				local suitLineCfg = self.et_active
				for k, v in pairs(suitLineCfg) do
					local spLine = SoraDGetChildByName(self.et_active, k)
					if spLine then
						local suitScale = display.height / 880 - 0.3
						spLine:setAnchorPoint(cc.p(0.5, 0))
						spLine:setScaleX(v.scaleX * suitScale)
						spLine:setScaleY(v.scaleY * suitScale)
					end
				end
				self.Node_effectActive:setVisible(true)
				self.et_active.action:gotoFrameAndPlay(0, false)
			end
		end)
		;(nil)[2] = cca.delay(0.5)
		;(nil)[3] = cca.callFunc(function()
			self.Image_sheer:setVisible(false)
			self.Button_light:setBright(true)
		end)
		;(nil)[4] = cca.callFunc(function()
			self.Image_sheer:setVisible(false)
			self.Button_light:setBright(true)
		end)
		self:runAction(cca.seq(nil))
	end
end
function eventLightShiningView:showActivedEffect(ret)
	self.Node_effectActived:setVisible(ret)
	if ret and not self.et_actived then
		self.et_actived = SoraDCreatAnimationEx("animationLSActived")
		self.et_actived:addTo(self.Node_effectActived)
	end
end
function eventLightShiningView:initData(target, data)
	SoraDCloseLoading(self)
	self.starNum = lightShiningCtrl:getStarPoint()
	for k, v in ipairs(self.flowerArray) do
		v:setStatus(k > self.starNum, self.starNum >= #self.flowerArray)
	end
	for i, h in ipairs(self.lineArray) do
		if self.starNum > 1 and i < self.starNum then
			h:setVisible(true)
		else
			h:setVisible(false)
		end
	end
	for i, h in ipairs(self.baseLineArray) do
		if self.starNum > 1 and i < self.starNum then
			h:setVisible(false)
		else
			h:setVisible(true)
		end
	end
	local isShow, retNum = lightShiningCtrl:getReceiveStatusAndNum()
	self.Image_redPoint:setVisible(isShow and 0 < retNum)
	self.Text_redPointInt:setVisible(0 < retNum)
	self.Text_redPointInt:setString(retNum)
	local isActive = lightShiningCtrl:isBuffActive()
	local ret = not isActive and self.starNum >= #self.flowerArray
	self.isLightToday = lightShiningCtrl:isLightToday()
	self.Button_light:setTouchEnabled(not self.isLightToday)
	self.Button_light:setVisible(not self.isLightToday)
	self.Node_btnEffect:setVisible(not self.isLightToday and self.starNum >= #self.flowerArray)
	self.Node_aniTop:setVisible(isActive)
	self.Button_light:setBright(not self.isLightToday and self.starNum >= #self.flowerArray)
	self.buffList = lightShiningCtrl:getBuffList()
	for k, v in ipairs(self.buffList) do
		if not self.buffItemArray[tostring(v)] then
			local buffItem = include("eventLightShiningBuff").new()
			buffItem:setPosition(0, 0)
			buffItem:addTo(self.Node_buff)
			self.buffItemArray[tostring(v)] = buffItem
		end
		self.buffItemArray[tostring(v)]:setBuff(self, v)
		self.buffItemArray[tostring(v)]:isActive(isActive and self.isLightToday)
	end
	self:sortBuffPos()
	self:showActivedEffect(isActive)
	if not self.isActed then
		self:runFadeInAct()
	end
end
function eventLightShiningView:sortBuffPos()
	_ENV, _ENV = nil, nil
	_UPVALUE1_, (nil)[1], (nil)[1] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[2] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[3] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[4] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[5] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[6] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[7] = nil, nil, cc.p(0, 0)
	_UPVALUE1_, (nil)[1], (nil)[8] = nil, nil, cc.p(0, 0)
	_UPVALUE2_, (nil)[2], (nil)[1] = nil, nil, cc.p(-90, 10)
	_UPVALUE2_, (nil)[2], (nil)[2] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[3] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[4] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[5] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[6] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[7] = nil, nil, cc.p(90, 10)
	_UPVALUE2_, (nil)[2], (nil)[8] = nil, nil, cc.p(90, 10)
	_UPVALUE3_, (nil)[3], (nil)[1] = nil, nil, cc.p(-150, 40)
	_UPVALUE3_, (nil)[3], (nil)[2] = nil, nil, cc.p(0, 0)
	_UPVALUE3_, (nil)[3], (nil)[3] = nil, nil, cc.p(150, 40)
	_UPVALUE3_, (nil)[3], (nil)[4] = nil, nil, cc.p(150, 40)
	_UPVALUE3_, (nil)[3], (nil)[5] = nil, nil, cc.p(150, 40)
	_UPVALUE3_, (nil)[3], (nil)[6] = nil, nil, cc.p(150, 40)
	_UPVALUE3_, (nil)[3], (nil)[7] = nil, nil, cc.p(150, 40)
	_UPVALUE3_, (nil)[3], (nil)[8] = nil, nil, cc.p(150, 40)
	_UPVALUE4_, (nil)[4], (nil)[1] = nil, nil, cc.p(-200, 50)
	_UPVALUE4_, (nil)[4], (nil)[2] = nil, nil, cc.p(-70, 10)
	_UPVALUE4_, (nil)[4], (nil)[3] = nil, nil, cc.p(70, 10)
	_UPVALUE4_, (nil)[4], (nil)[4] = nil, nil, cc.p(200, 50)
	_UPVALUE4_, (nil)[4], (nil)[5] = nil, nil, cc.p(200, 50)
	_UPVALUE4_, (nil)[4], (nil)[6] = nil, nil, cc.p(200, 50)
	_UPVALUE4_, (nil)[4], (nil)[7] = nil, nil, cc.p(200, 50)
	_UPVALUE4_, (nil)[4], (nil)[8] = nil, nil, cc.p(200, 50)
	;(nil)[5], (nil)[1] = nil, cc.p(-240, 60)
	;(nil)[5], (nil)[2] = nil, cc.p(-120, 30)
	;(nil)[5], (nil)[3] = nil, cc.p(0, 0)
	;(nil)[5], (nil)[4] = nil, cc.p(120, 30)
	;(nil)[5], (nil)[5] = nil, cc.p(240, 60)
	;(nil)[5], (nil)[6] = nil, cc.p(240, 60)
	;(nil)[5], (nil)[7] = nil, cc.p(240, 60)
	;(nil)[5], (nil)[8] = nil, cc.p(240, 60)
	local posCfg
	local posList = posCfg[#self.Node_buff:getChildren()]
	for k, v in ipairs(self.Node_buff:getChildren()) do
		v:setPosition(posList[k])
	end
end
function eventLightShiningView:drawBaseLine(target1, target2)
	local pos1 = cc.p(target1:getPositionX(), target1:getPositionY())
	local pos2 = cc.p(target2:getPositionX(), target2:getPositionY())
	local line = cc.DrawNode:create()
	line:setPosition(0, 0)
	line:drawSegment(pos1, pos2, 1.5, COLOR_GRAY)
	return line
end
function eventLightShiningView:drawLine(target1, target2, index)
	_ENV, _ENV = nil, nil
	;(nil).rotation = -40
	;(nil).scaleX = 1
	_ENV, (nil)[1], (nil).scaleY = nil, nil, 1
	;(nil).rotation = -150
	;(nil).scaleX = 1.3
	_ENV, (nil)[2], (nil).scaleY = nil, nil, 1.07
	;(nil).rotation = -20
	;(nil).scaleX = 1.3
	;(nil)[3], (nil).scaleY = nil, 1.07
	local rotationCfg
	local pos1 = cc.p(target1:getPositionX(), target1:getPositionY())
	local pos2 = cc.p(target2:getPositionX(), target2:getPositionY())
	local line = display.newSprite("#dh_ghzs1_00.png")
	SoraDMixtureGLONE(line)
	line:setPosition((pos1.x + pos2.x) / 2, (pos1.y + pos2.y) / 2)
	line:setRotation(rotationCfg[index].rotation)
	line:setScaleX(rotationCfg[index].scaleX)
	line:setScaleY(rotationCfg[index].scaleY)
	local frames = display.newFrames("dh_ghzs1_%.2d.png", 0, 14)
	local animation = display.newAnimation(frames, 1.2 / #frames)
	line:playAnimationForever(animation)
	return line
end
function eventLightShiningView:setTime()
	self.Text_time:setTimeLast(function(ticket)
		return i18n("common_text_2669") .. ticket
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function eventLightShiningView:onQuestTouchClick()
	SoraDCreatePanel("eventLightShiningTaskView"):show()
end
function eventLightShiningView:onLightClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not self.isLightToday and self.starNum >= #self.flowerArray then
			SoraDShowLoading(self)
			self:showLightBtnAct()
			lightShiningCtrl:sendReqOpenBuff()
		else
			SoraDShowMsgTip(i18n("Shine_text_02"))
		end
	end
end
function eventLightShiningView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_3657"
		;("common_text_3657")[1] = i18n("Shine_text_01")
		;("common_text_3657")[2] = i18n("Shine_text_01")
		SoraDShowFixWindow(i18n("common_text_3657"), "common_text_3657")
	end
end
return eventLightShiningView
