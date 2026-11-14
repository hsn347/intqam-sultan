local gametop = gModuleMgr.getObject("gametop")
local spiritualGiftRead = include("spiritualGiftRead")
local spiritualGiftCtrl = SoraDGetCtrl("spiritualGiftCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local spiritualGiftGold = class("spiritualGiftGold", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("spiritualGiftGold")
	end
	return target
end)
function spiritualGiftGold:ctor()
	self.group = activityShowCtrl:getParamByID(gActivityTimeActivityID.SPIRITUAL_GIFT).classtype
	self:initWidget()
	self:fitDevice()
	self:showShaderEffect()
end
function spiritualGiftGold:fitDevice()
	if math.floor(display.height) < 960 then
		self.Center_Node:setScale(0.7)
		self.Center_Node:setPositionX(70)
	end
end
function spiritualGiftGold:showShaderEffect()
	if not self.meshNode2 then
		local _shader = require("app.game.eventCenterView.eventTemplate.spiritualGift.Shader_ljlnf_Flow_002")
		local _meshData = require("app.game.eventCenterView.eventTemplate.spiritualGift.MeshData_ljlnf_Flow_002")
		local _param = require("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002")
		_ENV = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").meshData = _meshData
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = _shader.vertBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), _shader.fragBytes
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").param = _param.param
		_ENV, ("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").pos = cc.p(320, 350), cc.p(320, 350)
		cc.p(320, 350).x = 0.4
		;("app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002").scale, cc.p(320, 350).y = cc.p(320, 350), 0.4
		local createData = "app.game.eventCenterView.eventTemplate.spiritualGift.ShaderCfg_ljlnf_Flow_002"
		local meshNode = SoraDCreateMeshNode(createData.meshData, createData.size, createData.shader, createData.param)
		meshNode:setPosition(cc.p(createData.pos))
		_ENV = cc.p(createData.pos)
		cc.p(createData.pos).x = 0
		cc.p(createData.pos).y = 0
		cc.p(createData.pos).z = 0
		meshNode:setRotation3D(cc.p(createData.pos))
		meshNode:setScale(createData.scale.x, createData.scale.y)
		meshNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		meshNode:addTo(self.Center_Node, -1)
		self.meshNode2 = meshNode
	end
end
function spiritualGiftGold:initWidget(...)
	SoraDGetAllChildFromWidget(self, self)
	SoraDCreatAnimation(self.__cname, self, true)
	SoraDMixtureGLONEByParent(self.Node_effect2)
	if SoraDGetDefaultLanguage() ~= "ar" and SoraDGetDefaultLanguage() ~= "en" then
		local str = "bg_spiritual_gift_gold_" .. SoraDGetDefaultLanguage() .. ".png"
		self.Sprite_title:setSpriteFrame(str)
	else
		self.Sprite_title:setSpriteFrame(SoraDFIsRA() and "farme_jlnf_gx_ar.png" or "farme_jlnf_gx_en.png")
	end
	self.Text_des1:setString(i18n("godGift_text_20"))
	self.Text_des2 = SoraDChangeTextToHtml(self.Text_des2)
	self.Text_des2:setColor(display.COLOR_WHITE)
	self.luckyNumberList = spiritualGiftRead:getLuckyNumberInfo(self.group)
end
function spiritualGiftGold:initData(data)
	local luckyNum = data.luckyNumber or 0
	local goldPer = data.luckyGold or 0
	local goldNum = data.curGold or 0
	local propotion = 0
	for i, v in ipairs(self.luckyNumberList) do
		if luckyNum == v.luckyNum then
			propotion = v.proportion / 10
		end
	end
	local goldPerStr = string.format("%d%%", propotion)
	self.Text_luckyNum:setString(luckyNum)
	_ENV = luckyNum
	_ENV, _ENV, luckyNum.coin = v.proportion, nil, goldPerStr
	_ENV, (nil).coin, v.proportion.color = v.proportion, v.proportion, "#FFFF00"
	;(nil).__default, v.proportion.color = v.proportion, "#D7C39B"
	local str = i18n_html("godGift_text_15", luckyNum, nil)
	self.Text_des2:setString(str)
	self.Text_gold:setString(string.formatnumberthousands(goldPer))
end
return spiritualGiftGold
