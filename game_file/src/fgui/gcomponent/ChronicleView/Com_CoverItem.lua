local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local mileStoneCtrl = gametop.playertop_:getModule("mileStoneCtrl")
local funUnlockRead = include("funUnlockRead")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_CoverItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_CoverItem", Com_CoverItem)
function Com_CoverItem:onInit()
	self.Node_Shader = display.newNode()
	self.fields.Node_Shader:displayObject():addChild(self.Node_Shader)
	self:hideAll()
	self:addClickListener(handler(self, self.onBtnItemClick))
end
function Com_CoverItem:onShow()
end
function Com_CoverItem:initData(data, index)
	self.data = data
	self.index = data.index
	if not self.data then
		return
	end
	self.fields.title:setString(i18n(self.data.title))
	self.fields.icon:setURL(self.data.bg)
	local key = legendMDesRead.getKeyByIndex(self.data.index)
	local showLv = funUnlockRead.getShowLevel(key)
	local unlockLv = funUnlockRead.getUnlockLevel(key)
	if showLv <= SoraDGetCastleLv() and unlockLv > SoraDGetCastleLv() then
		self.fields.icon:setGrayed(true)
		self.fields.Com_Lock:setVisible(true)
		self.unlockLv = unlockLv
	else
		self.fields.icon:setGrayed(false)
		self.fields.Com_Lock:setVisible(false)
		self.unlockLv = nil
	end
	self:updateStatus()
	if not self.newSp then
		self.newSp = display.newSprite("#" .. self.data.bg, 0, 0)
		self.newSp:setAnchorPoint(cc.p(0, 0))
		self.newSp:addTo(self.Node_Shader)
		self.newSp:setVisible(false)
		self:runAction(ffa.seq(ffa.delay((index - 1) * 0.15), ffa.callFunc(function()
			self:add3DAnimation()
		end)))
	end
end
function Com_CoverItem:hideAll()
end
function Com_CoverItem:showAll()
	self.transitions.t0:play(1, 0, 0, -1)
end
function Com_CoverItem:updateStatus()
	print("self.index", self.index)
	if self.index ~= gLegendHistoryCoverType.MILESTONE then
		local statusData = legendMCtrl:getCoverStatusData(self.index)
		self.fields.frame_new:setVisible(false)
		self.fields.Button_item:setVisible(false)
		if statusData and statusData.status and not self.unlockLv then
			self.fields.img_tip_icon:setVisible(true)
			self.fields.fram_bg:setVisible(true)
		else
			self.fields.img_tip_icon:setVisible(false)
			self.fields.fram_bg:setVisible(false)
		end
	else
		self.fields.img_tip_icon:setVisible(false)
		local isShowGift = mileStoneCtrl:isHaveGift()
		self.fields.Button_item:setVisible(isShowGift and not self.unlockLv)
		local curTask = mileStoneCtrl:getCurTask()
		_ENV = nil
		;(nil).byLTID = true
		local lastClickTask = SoraDConfigGet("Game:legendMView:frameNew~string", nil)
		self.fields.frame_new:setVisible(not isShowGift and curTask .. "" ~= lastClickTask and not self.unlockLv)
		self.fields.fram_bg:setVisible(self.fields.Button_item:isVisible() or self.fields.frame_new:isVisible())
	end
end
function Com_CoverItem:add3DAnimation()
	local bottomWaterShader = require("app.game.legend.shader.legendM")
	local bottomMeshData = require("app.game.legend.meshData.legendM_meshData")
	local renderTexture = cc.RenderTexture:create(480, 226, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	local renderSprite = renderTexture:getSprite()
	renderTexture:addTo(self.Node_Shader)
	renderSprite:setAnchorPoint(cc.p(0, 0))
	renderTexture:setPosition(0, 0)
	renderTexture:beginWithClear(0, 0, 0, 0)
	self.newSp:setVisible(true)
	self.Node_Shader:visit()
	self.fields.icon:visit()
	self.fields.icon:setVisible(false)
	self.newSp:setVisible(false)
	renderTexture:endToLua()
	self.renderSprite = renderSprite
	_ENV, _UPVALUE8_, self.renderTexture = renderTexture, renderTexture.endToLua, renderTexture
	renderTexture.attr = "#texture"
	renderTexture.name = "_first_tex"
	renderTexture.value = self.renderSprite:getTexture()
	_ENV, renderTexture.hasMipmap = self.renderSprite:getTexture(), false
	self.renderSprite:getTexture().attr = "texture"
	self.renderSprite:getTexture().name = "_rj"
	self.renderSprite:getTexture().value = "3DTexture/legendM/rongjie.png"
	_UPVALUE4_, self.renderSprite:getTexture().hasMipmap = self.renderSprite, false
	_ENV, self.renderSprite:getTexture().texParam, self.renderSprite[1] = self.renderSprite, self.renderSprite, gl.LINEAR
	_ENV, self.renderSprite:getTexture().texParam, self.renderSprite[2] = self.renderSprite, self.renderSprite, gl.LINEAR
	_ENV, self.renderSprite:getTexture().texParam, self.renderSprite[3] = self.renderSprite, self.renderSprite, gl.REPEAT
	_ENV, self.renderSprite:getTexture().texParam, self.renderSprite[4] = self.renderSprite, self.renderSprite, gl.REPEAT
	self.renderSprite.attr = "vec4"
	_ENV, self.renderSprite.name = gl.LINEAR, "_first_tex_ST"
	gl.LINEAR.x = 1.0
	gl.LINEAR.y = 1.0
	gl.LINEAR.z = 0.0
	_ENV, self.renderSprite.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.LINEAR, "_rj_ST"
	gl.LINEAR.x = 1.0
	gl.LINEAR.y = -1.0
	gl.LINEAR.z = 0.0
	_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0.0
	gl.LINEAR.attr = "vec4"
	_ENV, gl.LINEAR.name = gl.REPEAT, "_color"
	gl.REPEAT.x = 0.3764705882352941
	gl.REPEAT.y = 0.11764705882352941
	gl.REPEAT.z = 0 / 255.0
	_ENV, gl.LINEAR.value, gl.REPEAT.w = gl.REPEAT, gl.REPEAT, 1.0
	gl.REPEAT.attr = "float"
	gl.REPEAT.name = "_rj_value"
	_ENV, gl.REPEAT.value = 0 / 255.0, -1.5
	;(0 / 255.0).attr = "float"
	;(0 / 255.0).name = "_light"
	_ENV, (0 / 255.0).value = cc.p(0, 0)
	cc.p(0, 0).attr = "float"
	cc.p(0, 0).name = "_ld"
	cc.p(0, 0).value = 0.0
	_ENV, renderTexture.endToLua[1] = renderTexture, renderTexture
	_ENV, renderTexture.endToLua[2] = renderTexture, self.renderSprite:getTexture()
	_ENV, renderTexture.endToLua[3] = renderTexture, self.renderSprite
	_ENV, renderTexture.endToLua[4] = renderTexture, gl.LINEAR
	_ENV, renderTexture.endToLua[5] = renderTexture, gl.LINEAR
	_ENV, renderTexture.endToLua[6] = renderTexture, gl.REPEAT
	_ENV, renderTexture.endToLua[7] = renderTexture, 0 / 255.0
	local _ENV, renderTexture.endToLua[8], bottomParam = renderTexture, cc.p(0, 0)
	renderTexture.meshData = bottomMeshData
	_ENV, renderTexture.size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = bottomWaterShader.vertBytes
	renderTexture.shader, cc.size(1, 1).fragBytes = cc.size(1, 1), bottomWaterShader.fragBytes
	renderTexture.param = bottomParam
	_ENV, renderTexture.pos = cc.p(240, 113), cc.p(240, 113)
	cc.p(240, 113).x = 240
	renderTexture.scale, cc.p(240, 113).y = cc.p(240, 113), 113
	local bottomWaterData = renderTexture
	local bottomWater = SoraDCreateMeshNode(bottomWaterData.meshData, bottomWaterData.size, bottomWaterData.shader, bottomWaterData.param)
	bottomWater:setPosition(cc.p(bottomWaterData.pos))
	bottomWater:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	bottomWater:setScale(bottomWaterData.scale.x, bottomWaterData.scale.y)
	bottomWater:addTo(self.Node_Shader, 0)
	self.bottomWater = bottomWater
	self.maxAnimate = -1.5
	self.realTime = 0
	if self.updateTimer then
		SoraDManagerRemoveTimer(self, self.updateTimer)
		self.updateTimer = nil
	end
	self:showAll()
	self.updateTimer = SoradCreateTimer(self, handler(self, self.updateAnimate), true)
end
function Com_CoverItem:updateAnimate(dt)
	self.realTime = self.realTime + dt * 1.0
	self.maxAnimate = self.maxAnimate + dt * 1.0
	if self.maxAnimate >= 0.5 then
		self.fields.icon:setVisible(true)
		self.renderTexture = nil
		self.renderSprite = nil
		if self.updateTimer then
			SoraDManagerRemoveTimer(self, self.updateTimer)
			self.updateTimer = nil
		end
		self.bottomWater:removeFromParent()
		self.bottomWater = nil
		return
	end
	self.bottomWater:getGLProgramState():setUniformFloat("_rj_value", self.maxAnimate)
end
function Com_CoverItem:onBtnItemClick()
	if self.bottomWater then
		return
	end
	SoraDPlaySound()
	if self.unlockLv then
		_ENV = nil
		;(nil).name = i18n(self.data.title)
		;(nil).lv = self.unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
		return
	end
	if self.index == gLegendHistoryCoverType.ALLIANCE_ACHIEVE and not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("common_text_583"))
		return
	end
	print(" self.index = ", self.index)
	if self.index == gLegendHistoryCoverType.CIVIL_WAR or self.index == gLegendHistoryCoverType.COUNTRY_WAR then
		local coverStatusData = legendMCtrl:getCoverStatusData(self.index)
		if coverStatusData and coverStatusData.count == 0 then
			SoraDShowMsgTip(i18n("history_text_05"))
			return
		end
	end
	if self.index == gLegendHistoryCoverType.BIOGRAPHY or self.index == gLegendHistoryCoverType.CIVIL_WAR or self.index == gLegendHistoryCoverType.COUNTRY_WAR then
		legendMCtrl:resetCoverStatusData(self.index)
		self:updateStatus()
	end
	if self.index == gLegendHistoryCoverType.MILESTONE then
		mileStoneCtrl:reqInitData()
		local curTask = mileStoneCtrl:getCurTask()
		_ENV = i18n("history_text_05")
		i18n("history_text_05").byLTID = true
		SoraDConfigSet("Game:legendMView:frameNew~string", curTask, i18n("history_text_05"))
	end
	_ENV = SoraDConfigSet
	SoraDConfigSet.msg = "MESSAGE_UI_LEGENDM_LOADPAGE"
	SoraDConfigSet.pageType = legendMDesRead.coverIndex2PageType[self.index]
	SoraDSendMessage(SoraDConfigSet)
end
return Com_CoverItem
