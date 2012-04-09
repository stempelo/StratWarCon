
class cCity {

	int intCityPlayerId;
	int iIslandListId;
	int intCellX, intCellY;
	int productionUnitTypeId;
	string productionUnitTypeName;
	int productionDaysLeft;
	int strength;

	cCity(int intCityPlayerId_, int intCellX_, int intCellY_, int iIslandListId_) {
		//println("cCity constructor for intCityPlayerId_=" + intCityPlayerId_+", iIslandListId_="+iIslandListId_);
		intCityPlayerId=intCityPlayerId_;
		iIslandListId=iIslandListId_;
		intCellX=intCellX_;
		intCellY=intCellY_;

		strength=1; //int(random(1,3));

		//if( intCityPlayerId_==1 ) {
			//println("cCity constructor for intCityPlayerId_=" + intCityPlayerId_ +" strength="+strength);
		//}

		if( intCityPlayerId_ != -1 ) {
			//println("is human or computer city so build a tank");
			// game rule: default initial production to Tank
			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();
			productionUnitTypeName = oUnitRef[0].getUnitName();
			//println("productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);

			oIslandList.updateIslandPlayerCityCount(getIslandId(), -1, intCityPlayerId_);

		} else { 
			//println("city is unoccupied so build nothing");
			// game rule: empty city does not produce anything
			productionUnitTypeId= -1; 
			productionDaysLeft = -1;
			productionUnitTypeName = "N/A";
			//println("productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);

			oIslandList.increaseUnoccupiedCityCount(iIslandListId_);
		}
	}

	string getLocation() { return nf(intCellX,3)+","+nf(intCellY,3); }
	
	int getCellX() { return intCellX; }
	int getCellY() { return intCellY; }
	
	int getPlayerId() { return intCityPlayerId; }
	int setPlayerId(int intCityPlayerId_) { intCityPlayerId=intCityPlayerId_; }

	int getIslandId() { return iIslandListId; }
	
	void printRowCol() {
		println("city at row="+intCellX+", col="+intCellY);
	}

	string getStatus() {

		string strStatus="Unoccupied";

		switch( getPlayerId() ) {
			case 1: 
				strStatus="player 1";
				break;
			case 2: 
				strStatus="player 2";
				break;
		}

		return strStatus;
	}

	boolean isNearby(int intCellX_, int intCellY_) {
		if ( abs(intCellX_ - intCellX)<=2 && abs(intCellY_ - intCellY)<=2 ) return true;
		else return false; 
	}

	bool isAt(cellRow_, cellCol_) {
		if( intCellX==cellRow_ && intCellY==cellCol_ ) return true
		else return false;
	}

	bool isOccupied() {
		if( intCityPlayerId==-1 ) return false;
		else return true;
	}


	bool isPort() {
	
		bool result=false;
		
		if (      oGrid.isSea(intCellX-1, intCellY-1) ) result=true;
		else if ( oGrid.isSea(intCellX-1, intCellY) ) result=true;
		else if ( oGrid.isSea(intCellX-1, intCellY+1) ) result=true;
		
		else if ( oGrid.isSea(intCellX, intCellY-1) ) result=true;
		else if ( oGrid.isSea(intCellX, intCellY+1) ) result=true;
		
		else if ( oGrid.isSea(intCellX+1, intCellY-1) ) result=true;
		else if ( oGrid.isSea(intCellX+1, intCellY) ) result=true;
		else if ( oGrid.isSea(intCellX+1, intCellY+1) ) result=true;
		
		return result;
	}
	
	bool isWithin(int iWithinNumCells, int cellX_, int cellY_) {
	
		if( ( intCellX >=(cellX_-iWithinNumCells) && intCellX <=(cellX_+iWithinNumCells) )
			&& ( intCellY >=(cellY_-iWithinNumCells) && intCellY <=(cellY_+iWithinNumCells) ) )
			return true;
		else return false;
	}

	// ***********************************************************
	// DRAW
	// ***********************************************************


	void Draw() {
	
		//println("in cCity.Draw(), intCityPlayerId=" + intCityPlayerId+" row="+intCellX+" col="+intCellY);

		//if ( intCellX >= oGrid.getShowFromCellY() && intCellX <= oGrid.getCellCountY()   &&   intCellY >= oGrid.getShowFromCellX() && intCellY <= oGrid.getCellCountX() )  {
		
		//if ( intCellX >= oGrid.getShowFromCellX() && intCellX <= (oGrid.getShowFromCellX() + oViewport.getViewportCellCountY() )   &&   intCellY >= oGrid.getShowFromCellY() && intCellY <= ( oGrid.getShowFromCellY() + oViewport.getViewportCellCountY() ) )  {
		if ( oViewport.isCellWithinViewport(intCellX, intCellY) ) { 
			
			
			int DisplayY=((intCellY-oGrid.getShowFromCellY()+1)*cellWidth)-(cellWidth-1);
			int DisplayX=((intCellX-oGrid.getShowFromCellX()+1)*cellHeight)-(cellHeight-1);
			
			if ( oGrid.isFogOfWar(intCellX, intCellY)==false ) { // for testing purposes
				switch(intCityPlayerId) {
					case -1:
						image( imgCity0, DisplayX, DisplayY );
						break;
					case 1:
						image( imgCity1, DisplayX, DisplayY );
						
						if( getProductionDaysLeft() > 0 ) {
							// show Production Days Left on city image
							fill(255);
							if ( getProductionDaysLeft() < 10 )
								rect(DisplayX+iNumberIndent,DisplayY+iNumberIndent,iNumberTextSize+1,iNumberTextSize+1);
							else 
								rect(DisplayX+iNumberIndent,DisplayY+iNumberIndent,iNumberTextSize+5,iNumberTextSize+1);
							fill(0);
							textSize(8);
							text(getProductionDaysLeft(), DisplayX+iNumberIndent, DisplayY+iNumberTextSize+1 );
							textSize(11);
						}

						break;				
					case 2:
						image( imgCity2, DisplayX, DisplayY );
						break;
				}
			}
			
			/*
			if ( oGrid.isFogOfWar(intCellX, intCellY)==true ) { // for testing purposes
				fill(0);
				textSize(8);
				text("F", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
				textSize(11);
			}
			*/
			
		}	

		//println("leaving cCity.Draw()");
	}


	void clearFogOfWar() {
	
		//println(" in city.clearFogOfWar() ");
		
		int x, y;
		int sx, sy;
		int ex, ey;
		
		if( intCellX-1>=oGrid.getShowFromCellX() ) sx=intCellX-1;
		else sx=intCellX;
		
		if( intCellX+1<= (oGrid.getShowFromCellX() + oViewport.getWidth() ) ) ex=intCellX+1;
		else ex=intCellX;
		
		
		if( intCellY-1>=oGrid.getShowFromCellY() ) sy=intCellY-1;
		else sy=intCellY;
				
		if( intCellY+1<= ( oGrid.getShowFromCellY() + oViewport.getHeight() ) ) ey=intCellY+1;
		else ey=intCellY;
		
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
				if (intCityPlayerId==1) oGrid.clearFogOfWar(x,y);
			}
		}
	}
	




	// ***********************************************************
	// PRODUCTION
	// ***********************************************************

	int getProductionUnitTypeId() { return productionUnitTypeId; }
	
	void setProductionUnitTypeId(int productionUnitTypeId_) { 
	
		//println("in city.setProductionUnitTypeId("+productionUnitTypeId_+")");
	
		if ( productionUnitTypeId_ == -1 ) {
			productionUnitTypeId= -1; 
			productionDaysLeft = -1;
			productionUnitTypeName = "N/A";
		} else {
			productionUnitTypeId=productionUnitTypeId_; 
			productionDaysLeft = oUnitRef[productionUnitTypeId_].getDaysToProduce();
			productionUnitTypeName = oUnitRef[productionUnitTypeId_].getUnitName();
		}
	}

	
	string getProductionUnitTypeName() { return productionUnitTypeName; }
	
	int getProductionDaysLeft() { return productionDaysLeft; }

	void manageProduction(int iCityListId_) {
	
		//println("in cCity.manageProduction() at ("+intCellX+","+intCellY+")");

		//if( intCityPlayerId > 0 && intCityPlayerId!=2) { // just testing
		if( intCityPlayerId > 0 ) {
		
			//println("in cCity.manageProduction() cityEmpty=false, productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);
			if( productionDaysLeft > 1 ) productionDaysLeft--;
			else {
				
				//println("in city.manageProduction() productionUnitTypeId="+productionUnitTypeId);
				
				// city has finished producing a unit
				
				oUnitList.AddUnit(productionUnitTypeId, intCityPlayerId, intCellX, intCellY, iIslandListId);
				
				// start building next unit
				
				//doNextUnitProductionAI(intCityPlayerId); // for testing purposes
				
				if( intCityPlayerId == 2 ) {
				
					doNextUnitProductionAI(intCityPlayerId);
								
				} else if( intCityPlayerId == 1 && oPlayer1.getIsAI() ) {

					if ( intCityPlayerId==1 ) oViewport.scrollIfAppropriate(intCellX, intCellY);				
					doNextUnitProductionAI(intCityPlayerId);

								
				} else if( intCityPlayerId == 1 ) {

					oViewport.scrollIfAppropriate(intCellX, intCellY);
				
					if( productionUnitTypeId!=-1) {
		
						productionUnitTypeId= oUnitRef[productionUnitTypeId].getUnitTypeId(); 
						productionDaysLeft = oUnitRef[productionUnitTypeId].getDaysToProduce();
					} else {
					
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
					}
					
					
					/*
					println("in city.manageProduction() player="+intCityPlayerId+" display city production dialogue...");
					oCityList.updateSelectedCityPanelInformation(iCityListId_);
					oGameEngine.setSelectedCityListId(iCityListId_);
					oDialogueCityProduction.display();
					*/
				}
				
			}
		} else {
			//println("in cCity.manageProduction() cityEmpty=true");
		}
	}


	void doNextUnitProductionAI(int iPlayerId_) {

		int numTanks=0;
		int numDestroyer=0;
		int numTransport=0;

		// ***************************
		// note: temporarily for AI testing purposes, don't build any: fighters, carrier, submarine, battleship, etc.
		// ***************************

		//numTank = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 0);
		if (iPlayerId_==1) numTank = oPlayer1.getUnitTypeCount(0);
		else if (iPlayerId_==2) numTank = oPlayer2.getUnitTypeCount(0);

		//numTransport = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 6);
		if (iPlayerId_==1) numTransport = oPlayer1.getUnitTypeCount(6);
		else if (iPlayerId_==2) numTransport = oPlayer2.getUnitTypeCount(6);

		//numDestroyer = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 5);
		if (iPlayerId_==1) numDestroyer = oPlayer1.getUnitTypeCount(5);
		else if (iPlayerId_==2) numDestroyer = oPlayer2.getUnitTypeCount(5);


		// ******************************************************
		// if player transport is nearby waiting for tanks, build more tanks
		if ( oUnitList.IsTransportNearbyWaitingForUnits( getPlayerId(), -1, getCellX(), getCellY() ) ) {

			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();


		// ******************************************************
		// else, player needs a minimum number of tanks
		//if (numTank<=2 || oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 0)<=2 ) {
		} else if (numTank<=6 || oGameEngine.getDayNumber()<=20) {

			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();


		// ******************************************************
		// else, player should have a minimum number of transports
		//} else if (isPort() && ( numTransport <= 1 && oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 6)<=1 ) ) {
		} else if (isPort() && numTransport <= 1 ) {

			productionUnitTypeId= oUnitRef[6].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[6].getDaysToProduce();


		// ******************************************************
		// else, player should have a minimum number of destroyers
		//} else if ( isPort() && ( numDestroyer <= 1  && oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 5)<=1 ) ) {
		} else if ( isPort() && numDestroyer <= 1 ) {

			productionUnitTypeId= oUnitRef[5].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[5].getDaysToProduce();


		// ******************************************************
		// else, if port city, build random unit
		} else if ( isPort() ) {
			switch( (int)random(1,8) ) {
				case 1:
					//productionUnitTypeId= oUnitRef[4].getUnitTypeId(); // carrier
					//productionDaysLeft = oUnitRef[4].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;	
				case 2:
					//productionUnitTypeId= oUnitRef[1].getUnitTypeId(); // fighter
					//productionDaysLeft = oUnitRef[1].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
				case 3:
					productionUnitTypeId= oUnitRef[3].getUnitTypeId(); // bomber
					productionDaysLeft = oUnitRef[3].getDaysToProduce();
					break;
				case 4:
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;	
				case 5:
					//productionUnitTypeId= oUnitRef[7].getUnitTypeId(); // submarine
					//productionDaysLeft = oUnitRef[7].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
				case 6:
					//productionUnitTypeId= oUnitRef[2].getUnitTypeId(); // battleship
					//productionDaysLeft = oUnitRef[2].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;	
				case 7:
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;	
					//productionUnitTypeId= oUnitRef[6].getUnitTypeId(); // transport
					//productionDaysLeft = oUnitRef[6].getDaysToProduce();
					//break;				
				case 8:
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
					//productionUnitTypeId= oUnitRef[5].getUnitTypeId(); // destroyer
					//productionDaysLeft = oUnitRef[5].getDaysToProduce();
					//break;						
			} 			

		// ******************************************************
		// else not a port city, build random unit			
		} else {
			switch( (int)random(1,4) ) {
				case 1:
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
				case 2:
					//productionUnitTypeId= oUnitRef[1].getUnitTypeId(); // fighter
					//productionDaysLeft = oUnitRef[1].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
				case 3:
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;						
				case 4:
					//productionUnitTypeId= oUnitRef[3].getUnitTypeId(); // bomber
					//productionDaysLeft = oUnitRef[3].getDaysToProduce();
					productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
					productionDaysLeft = oUnitRef[0].getDaysToProduce();
					break;
			} 			
		}
		
	}

	
}



