local baseComponent = require("fgui.base.baseComponent")
local Com_3dPet = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_3dPet", Com_3dPet)
function Com_3dPet:onInit()
	self.fields.Loader3D:setTouchEnabled(true)
	local petNode = SoraDCreatePanel("petShowSingle")
	self.petNode = petNode
	self.petNode:setName("pet3d")
	self.petNode.petScale = 1
	self.petNode:setPosition(0, 0)
	self.petNode:setIsView(true)
	self.fields.Loader3D:setContent(petNode)
end
function Com_3dPet:onShow()
end
function Com_3dPet:initData(curPetParam)
	if self.petNode.curPid ~= curPetParam.pid or self.petNode.curRank ~= curPetParam.rank then
		self.petNode:initData(curPetParam)
	end
end
function Com_3dPet:setPetScale(scale)
	self.petNode.petScale = scale
	self.petNode:setSpriteRelativeScale(self.petNode.petScale)
end
function Com_3dPet:playUpgradeEffect(needAction, needProtected, protectTime)
	self.petNode:playUpgradeEffect(needAction, needProtected, protectTime)
end
return Com_3dPet
