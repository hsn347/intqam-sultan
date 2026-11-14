local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildSawMill = class("cityBuildSawMill", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildSawMill:ctor()
	self.viewModel = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
end
function cityBuildSawMill:loadView()
	self:loadBaseView()
end
function cityBuildSawMill:updateViewModel()
	local bid = self:getBuildBid()
	local viewModel = self:getViewModel()
	if self.viewModel ~= viewModel then
		self.viewModel = viewModel
		self:updateViewByModel(viewModel)
	end
end
function cityBuildSawMill:updateViewByModel(viewModel)
	local bid = self:getBuildBid()
	if bid ~= BUILDID.SAWMILL then
		return
	end
	local updateFunc = "updateViewModel" .. viewModel
	self[updateFunc](self)
end
function cityBuildSawMill:getViewModel()
	local tblViewModelCfg = cityBuildViewDef.tblViewModelSawMill
	local lv = self:getBuildLv()
	return self:getViewModelByLv(lv, tblViewModelCfg)
end
function cityBuildSawMill:updateViewModel1()
end
function cityBuildSawMill:updateViewModel2()
	self:loadNodeByName("fmc_house_01")
end
function cityBuildSawMill:updateViewModel3()
	self:removeNodeByName("fmc_tree_01")
	self:removeNodeByName("fmc_house_01")
	self:loadNodeByName("fmc_tree_02")
	self:loadNodeByName("fmc_house_02")
end
function cityBuildSawMill:updateViewModel4()
	self:removeNodeByName("fmc_tree_01")
	self:removeNodeByName("fmc_house_02")
	self:loadNodeByName("fmc_tree_02")
	self:loadNodeByName("fmc_house_03")
end
function cityBuildSawMill:updateViewModel5()
	self:removeNodeByName("fmc_tree_01")
	self:removeNodeByName("fmc_house_03")
	self:loadNodeByName("fmc_tree_02")
	self:loadNodeByName("fmc_house_04")
end
function cityBuildSawMill:turnToHarvestView(animated)
	local viewModel = self:getViewModel()
	local turnToFunc = "turnToHarvestView" .. viewModel
	if self[turnToFunc] then
		self[turnToFunc](self, animated)
	end
end
function cityBuildSawMill:turnToNormalView(animated)
	local viewModel = self:getViewModel()
	local turnToFunc = "turnToNormalView" .. viewModel
	if self[turnToFunc] then
		self[turnToFunc](self, animated)
	end
end
function cityBuildSawMill:doTurnView(nameHide, nameShow, animated)
	if animated then
		local delayTime = cca.delay(0.4)
		local callFuncHide = cca.callFunc(function()
			local fadeOut = cca.fadeOut(0.8)
			if self[nameHide] then
				self[nameHide]:runAction(fadeOut)
			end
		end)
		local callFuncShow = cca.callFunc(function()
			self:removeNodeByName(nameHide)
			self:loadNodeByName(nameShow)
			self[nameShow]:setOpacity(0)
			local fadeIn = cca.fadeIn(0.8)
			self[nameShow]:runAction(fadeIn)
		end)
		_UPVALUE3_ = nil
		;(nil)[1] = callFuncHide
		;(nil)[2] = delayTime
		;(nil)[3] = callFuncShow
		local actSeq = cca.seq(nil)
		self:runAction(actSeq)
	else
		self:removeNodeByName(nameHide)
		self:loadNodeByName(nameShow)
	end
end
function cityBuildSawMill:turnToHarvestView1(animated)
	local fmc_tree = "fmc_tree_01"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_tree, fmc_wood, animated)
end
function cityBuildSawMill:turnToHarvestView2(animated)
	local fmc_tree = "fmc_tree_01"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_tree, fmc_wood, animated)
end
function cityBuildSawMill:turnToHarvestView3(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_tree, fmc_wood, animated)
end
function cityBuildSawMill:turnToHarvestView4(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_tree, fmc_wood, animated)
end
function cityBuildSawMill:turnToHarvestView5(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_tree, fmc_wood, animated)
end
function cityBuildSawMill:turnToNormalView1(animated)
	local fmc_tree = "fmc_tree_01"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_wood, fmc_tree, animated)
end
function cityBuildSawMill:turnToNormalView2(animated)
	local fmc_tree = "fmc_tree_01"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_wood, fmc_tree, animated)
end
function cityBuildSawMill:turnToNormalView3(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_wood, fmc_tree, animated)
end
function cityBuildSawMill:turnToNormalView4(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_wood, fmc_tree, animated)
end
function cityBuildSawMill:turnToNormalView5(animated)
	local fmc_tree = "fmc_tree_02"
	local fmc_wood = "fmc_wood"
	self:doTurnView(fmc_wood, fmc_tree, animated)
end
return cityBuildSawMill
