local GROU_ID = worldMapDefine.GROU_ID
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local worldMapProtal = class("worldMapProtal", function(target)
	local target = include("worldMapInstance").new("worldMapProtal")
	return target
end)
function worldMapProtal:ctor()
	local effect = SoraDCreatAnimation("xueshan")
	effect:addTo(self, -1)
	effect:setPosition(-30, 25)
	effect:setScale(0.82)
	SoraDMixtureGLONEByParent(effect)
	self.effect = effect
	self.bgImage = SoraDGetChildByName(effect, "xueshan_2")
	self.image_name = display.newSprite("#frame_map_07.png")
	self.image_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 80))
	self.image_name:addTo(self, 3)
	self.image_name:setGroupID(GROU_ID.group_level_build)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 20
	self.text_Name = SoraDCreateLabel(self.image_name)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 85))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	self.text_Name:addTo(self, 4)
	self.text_Name:setGroupID(GROU_ID.group_text)
	self:addShaderEffect()
	self:_initData()
end
function worldMapProtal:initInstanceData(buildClassID)
	self.buildClassID = buildClassID
	local config = endlessTrialsCtrl:getMountainConfig(self.buildClassID)
	dump(config, "sdkjflksdjf")
	self.text_Name:setString(i18n(config.name))
end
function worldMapProtal:setBatchNodeGroupID(groupID)
	self.bgImage:setGroupID(groupID)
end
function worldMapProtal:onClickInstance(onShowView)
	if worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	self:playClickSound()
	local selectShowPanel = SoraDCreatePanel("endlessTrialsProtal")
	selectShowPanel:initData(self.buildClassID, self.tilePoint)
	selectShowPanel:show()
	return selectShowPanel, false
end
function worldMapProtal:playClickSound()
	SoraDPlaySound("worldmap", 5)
end
function worldMapProtal:addShaderEffect(...)
	local node = display.newNode()
	node:addTo(self.effect)
	node:setPosition(50, 60)
	_ENV, _ENV = node, node.setPosition
	node.shader = include("rongyan1")
	node.mesh = include("wind3_meshData")
	_ENV, node.cfg = include("wind3_shaderCfg"), include("wind3_shaderCfg")
	include("wind3_shaderCfg").x = 1.435527
	node.scale, include("wind3_shaderCfg").y = include("wind3_shaderCfg"), 1.224584
	_ENV, node.setPosition[1], node.pos = node, node, cc.p(4, 2)
	node.shader = include("rongyan1")
	node.mesh = include("wind4_meshData")
	_ENV, node.cfg = include("wind4_shaderCfg"), include("wind4_shaderCfg")
	include("wind4_shaderCfg").x = 1.265592
	node.scale, include("wind4_shaderCfg").y = include("wind4_shaderCfg"), 1.265592
	_ENV, node.setPosition[2], node.pos = node, node, cc.p(4.5, 0)
	node.shader = include("rongyan1")
	node.mesh = include("wind5_meshData")
	_ENV, node.cfg = include("wind5_shaderCfg"), include("wind5_shaderCfg")
	include("wind5_shaderCfg").x = 1.160811
	node.scale, include("wind5_shaderCfg").y = include("wind5_shaderCfg"), 1.160812
	_ENV, node.setPosition[3], node.pos = node, node, cc.p(3.5, 4)
	node.shader = include("wind12_shader")
	node.mesh = include("wind12_meshData")
	_ENV, node.cfg = include("wind12_shaderCfg"), include("wind12_shaderCfg")
	include("wind12_shaderCfg").x = 1.586068
	node.scale, include("wind12_shaderCfg").y = include("wind12_shaderCfg"), 1.586068
	node.setPosition[4], node.pos = node, cc.p(0, 5)
	local tab = node.setPosition
	for i, v in ipairs(tab) do
		_ENV = nil
		_ENV, (nil).meshData = v.mesh, v.mesh
		v.mesh.vertBytes = v.shader.vertBytes
		;(nil).shader, v.mesh.fragBytes = v.mesh, v.shader.fragBytes
		;(nil).param = v.cfg.param
		_ENV, (nil).pos = v.pos or cc.p(0, 0), v.pos or cc.p(0, 0)
		;(v.pos or cc.p(0, 0)).x = 0.15 * v.scale.x
		;(nil).scale, (v.pos or cc.p(0, 0)).y = v.pos or cc.p(0, 0), 0.15 * v.scale.y
		local createData
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.ONE, gl.ONE)
		meshNode:addTo(node)
	end
end
return worldMapProtal
