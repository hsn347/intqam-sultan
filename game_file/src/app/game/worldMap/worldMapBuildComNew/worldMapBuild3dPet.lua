local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuild3dPet = class("worldMapBuild3dPet", worldMapBuildComNew)
function worldMapBuild3dPet:ctor(...)
	worldMapBuild3dPet.super.ctor(self, ...)
end
function worldMapBuild3dPet:test3dPet()
	if not self.groundPet then
		local groundPetNode = SoraDCreatePanel("petShowSingle")
		_ENV = "petShowSingle"
		;("petShowSingle").petid = 1259
		;("petShowSingle").level = 27
		local ("petShowSingle").rank, curPetParam = 1, "petShowSingle"
		curPetParam.isShowPu = false
		groundPetNode:initData(curPetParam)
		local petCenterPos = cc.p(150, 0)
		groundPetNode:setPosition(petCenterPos)
		groundPetNode:setPositionZ(0)
		groundPetNode:setScale(0.3)
		groundPetNode:openMoveTouch(false)
		_ENV = false
		;(false).x = 20
		;(false).y = 34
		;(false).z = -10
		groundPetNode.petRootNode:setRotation3D(false)
		groundPetNode:setName("groundPetNode")
		groundPetNode:setIsForceOrthographic(true)
		self.target_:addChild(groundPetNode, 1100, "groundPetNode")
		self.groundPet = groundPetNode
		gGroudPet = groundPetNode
	end
end
return worldMapBuild3dPet
