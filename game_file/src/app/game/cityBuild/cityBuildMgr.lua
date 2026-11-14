cityBuildMgr, _ENV = nil, nil
function cityBuildMgr:initWithData(mainCity)
	self.mainCity = mainCity
end
function cityBuildMgr:clean()
	self.mainCity = nil
end
function cityBuildMgr:getBuildByIndex(buildIndex)
	if not self.mainCity then
		return nil
	end
	assert(self.mainCity, "mainCity cannot be nil")
	return self.mainCity:getBuildByIndex(buildIndex)
end
function cityBuildMgr:getBuildByBid(bid, iid)
	if not self.mainCity then
		return nil
	end
	assert(self.mainCity, "mainCity cannot be nil")
	local buildIndex = self.mainCity:getBuildIndexByBid(bid, iid)
	if buildIndex then
		return self.mainCity:getBuildByIndex(buildIndex)
	end
end
return cityBuildMgr
