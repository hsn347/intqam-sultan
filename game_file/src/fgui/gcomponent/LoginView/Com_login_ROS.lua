local baseComponent = require("fgui.base.baseComponent")
local Com_login_ROS = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LoginView/Com_login_ROS", Com_login_ROS)
function Com_login_ROS:onInit()
	self:addEffectLogin()
end
function Com_login_ROS:onShow()
	self:setPositionY(display.rheight / 2 + (1386 - display.rheight) * 0.2)
end
function Com_login_ROS:addEffectLogin()
	self.loginInitBg2 = display.newSprite("SinglePicture/loginInitBg2.png")
	self.loginInitBg2:setPosition(320, -693)
	self.fields.bg:setContent(self.loginInitBg2)
	local _shader = require("app.game.loginView.Shader_loginView_shader")
	local _meshData = require("app.game.loginView.Shader_loginView_meshData")
	local _param = require("app.game.loginView.Shader_loginView_shaderCfg")
	_ENV = "app.game.loginView.Shader_loginView_shaderCfg"
	;("app.game.loginView.Shader_loginView_shaderCfg").meshData = _meshData
	_ENV, ("app.game.loginView.Shader_loginView_shaderCfg").size = cc.size(0, 111), cc.size(0, 111)
	cc.size(0, 111).vertBytes = _shader.vertBytes
	;("app.game.loginView.Shader_loginView_shaderCfg").shader, cc.size(0, 111).fragBytes = cc.size(0, 111), _shader.fragBytes
	;("app.game.loginView.Shader_loginView_shaderCfg").param = _param.param
	_ENV, ("app.game.loginView.Shader_loginView_shaderCfg").pos = cc.p(320, 1050), cc.p(320, 1050)
	cc.p(320, 1050).x = 0.41600000000000004
	;("app.game.loginView.Shader_loginView_shaderCfg").scale, cc.p(320, 1050).y = cc.p(320, 1050), 0.4498
	local createData = "app.game.loginView.Shader_loginView_shaderCfg"
	local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
	meshNode:setPosition(cc.p(createData.pos))
	meshNode:setScale(createData.scale.x, createData.scale.y)
	meshNode:setBlendFunc(gl.ONE, gl.ONE)
	meshNode:addTo(self.loginInitBg2, 99)
	self.etStar = cc.ParticleSystemQuad:create("Particle_login/et_Particle_dljm_001.plist")
	self.etStar:setScaleX(1.4234)
	self.etStar:setScaleY(4.5)
	self.etStar:setRotation(-109.33)
	self.etStar:setPosition(cc.p(501.17, display.height + 100))
	self.etStar:addTo(self.loginInitBg2, 1)
end
return Com_login_ROS
