local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildEpicBattle = class("cityBuildEpicBattle", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildEpicBattle:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.EpicBattle)
	self.bid = cityBuildConstDef.fixedBuildDef.EpicBattle
	print("create cityBuildEpicBattle ", self.bid)
end
function cityBuildEpicBattle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_EPICBATTLE_VIEW", handler(self, self.msgUpdateView))
	self:updateView()
end
function cityBuildEpicBattle:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("soldier_rush_text_01"), i18n("soldier_rush_text_01")
	i18n("soldier_rush_text_01").x = 0
	;(nil).pos, i18n("soldier_rush_text_01").y = i18n("soldier_rush_text_01"), -120
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildEpicBattle:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_EPICBATTLE_VIEW")
	self:updateView()
end
function cityBuildEpicBattle:updateView()
	self:updateIsLock()
end
function cityBuildEpicBattle:initShadersAndParticles()
	local circle1Shader = require("app.game.cityBuild.shader.shishitongshuai")
	local circle1MeshData = require("app.game.cityBuild.meshData.SM_Ring_sstshd_001_meshData")
	local circle1Param = require("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg")
	_ENV = "app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg"
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").meshData = circle1MeshData
	_ENV, ("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = circle1Shader.vertBytes
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), circle1Shader.fragBytes
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").param = circle1Param.param
	_ENV, ("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").pos = cc.p(-5, -150), cc.p(-5, -150)
	cc.p(-5, -150).x = 0.16
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg").scale, cc.p(-5, -150).y = cc.p(-5, -150), 0.16
	local circle1CreateData = "app.game.cityBuild.shaderCfg.SM_Ring_sstshd_001_shaderCfg"
	local circle1MeshNode = SoraDCreateMeshNode(circle1CreateData.meshData, circle1CreateData.size, circle1CreateData.shader, circle1CreateData.param)
	circle1MeshNode:setPosition(cc.p(circle1CreateData.pos))
	circle1MeshNode:setScale(circle1CreateData.scale.x, circle1CreateData.scale.y)
	circle1MeshNode:setBlendFunc(gl.ONE, gl.ONE)
	_ENV = gl.ONE
	gl.ONE.x = 0
	gl.ONE.y = 0
	gl.ONE.z = 0
	circle1MeshNode:setRotation3D(gl.ONE)
	circle1MeshNode:addTo(self)
	self.circle1MeshNode = circle1MeshNode
	local circle2Shader = require("app.game.cityBuild.shader.shishitongshuai")
	local circle2MeshData = require("app.game.cityBuild.meshData.SM_Ring_sstshd_002_meshData")
	local circle2Param = require("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg")
	_ENV = "app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg"
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").meshData = circle2MeshData
	_ENV, ("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = circle2Shader.vertBytes
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), circle2Shader.fragBytes
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").param = circle2Param.param
	_ENV, ("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").pos = cc.p(-5, -150), cc.p(-5, -150)
	cc.p(-5, -150).x = 0.16
	;("app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg").scale, cc.p(-5, -150).y = cc.p(-5, -150), 0.16
	local circle2CreateData = "app.game.cityBuild.shaderCfg.SM_Ring_sstshd_002_shaderCfg"
	local circle2MeshNode = SoraDCreateMeshNode(circle2CreateData.meshData, circle2CreateData.size, circle2CreateData.shader, circle2CreateData.param)
	circle2MeshNode:setPosition(cc.p(circle2CreateData.pos))
	circle2MeshNode:setScale(circle2CreateData.scale.x, circle2CreateData.scale.y)
	circle2MeshNode:setBlendFunc(gl.ONE, gl.ONE)
	_ENV = gl.ONE
	gl.ONE.x = 0
	gl.ONE.y = 0
	gl.ONE.z = 0
	circle2MeshNode:setRotation3D(gl.ONE)
	circle2MeshNode:addTo(self, -1)
	self.circle2MeshNode = circle2MeshNode
end
function cityBuildEpicBattle:judgeClose()
	local isOpen = clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE) or false
	if self.circle1MeshNode and self.circle2MeshNode then
		self.circle1MeshNode:setVisible(isOpen)
		self.circle2MeshNode:setVisible(isOpen)
	elseif isOpen then
		self:initShadersAndParticles()
	end
end
return cityBuildEpicBattle
