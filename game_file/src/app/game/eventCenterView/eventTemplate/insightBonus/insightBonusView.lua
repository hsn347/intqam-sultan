local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local insightBonusView = class("insightBonusView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("insightBonusView")
	end
	return target
end)
function insightBonusView:ctor()
	self:initControls()
	self:initData()
end
function insightBonusView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.buttonGoCallBack))
	self.Text_ins:setString(i18n("addition_text_01"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.HERO_AWAKE_ACTIVTY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.Text_time:setString(SoraDConvertSecondToString(leftTime))
		self.Text_time:beginTime(leftTime)
	end
end
function insightBonusView:initShaderEffect()
	if not self.meshNode1 then
		local _shader = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param")
		_ENV = "app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param"
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").pos = cc.p(0, 200), cc.p(0, 200)
		cc.p(0, 200).x = 1.1
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param").scale, cc.p(0, 200).y = cc.p(0, 200), 0.7
		local createData = "app.game.eventCenterView.eventTemplate.insightBonus.lw_d1.lw_d1_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.Center_Node, -1)
		self.meshNode1 = meshNode
	end
	if not self.meshNode2 then
		local _shader = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param")
		_ENV = "app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param"
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").pos = cc.p(0, 350), cc.p(0, 350)
		cc.p(0, 350).x = 0.8
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param").scale, cc.p(0, 350).y = cc.p(0, 350), 0.7
		local createData = "app.game.eventCenterView.eventTemplate.insightBonus.lw_d3.lw_d3_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.Center_Node, 11)
		self.meshNode2 = meshNode
	end
	if not self.meshNode3 then
		local _shader = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param")
		_ENV = "app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param"
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").pos = cc.p(0, -120), cc.p(0, -120)
		cc.p(0, -120).x = 0.14
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param").scale, cc.p(0, -120).y = cc.p(0, -120), 0.14
		local createData = "app.game.eventCenterView.eventTemplate.insightBonus.lw_lghc.lw_lghc_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.Center_Node, 11)
		self.meshNode3 = meshNode
	end
	if not self.meshNode4 then
		local _shader = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param")
		_ENV = "app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param"
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").pos = cc.p(0, 50), cc.p(0, 50)
		cc.p(0, 50).x = 0.5
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param").scale, cc.p(0, 50).y = cc.p(0, 50), 0.5
		local createData = "app.game.eventCenterView.eventTemplate.insightBonus.lw_xx.lw_xx_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.Center_Node, 11)
		self.meshNode4 = meshNode
	end
	if not self.meshNode5 then
		local _shader = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_shader")
		local _meshData = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_meshData")
		local _param = require("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param")
		_ENV = "app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param"
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").pos = cc.p(-90, 330), cc.p(-90, 330)
		cc.p(-90, 330).x = 0.14
		;("app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param").scale, cc.p(-90, 330).y = cc.p(-90, 330), 0.2
		local createData = "app.game.eventCenterView.eventTemplate.insightBonus.lw_xz.lw_xz_param"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 22
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:addTo(self.Center_Node, 11)
		self.meshNode5 = meshNode
	end
end
function insightBonusView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function insightBonusView:initData()
end
function insightBonusView:buttonGoCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		uiManager:show("newHeroListView")
	end
end
function insightBonusView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.HERO_AWAKE_ACTIVTY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return insightBonusView
