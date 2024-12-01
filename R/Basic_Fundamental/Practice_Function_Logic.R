order <- function(){
  username <- readline("type your name: ")
  message(paste(username, "Welcome to 'Pizza Funwan' Do you want to view the menu?"))
  if (tolower(readline("Yes / No: ")) == "yes") {
    menu <- data.frame(
      id = 1:7,
      name = c("Hawaiian","Veggie","Seafood","BBQ chicken","Cheese","Water","Soda"),
      price = c(200,250,280,180,150,20,30)
    )
    print(menu,row.names=F)
  } 
  else { 
    print("OK Let's to next step !!")
  }
  
  total = 0
  message("Please input menu_id for select your pizze/drink. If finish order please input 'f'")
  message("Today, Buy 1000 get 100 special discount")
  
  while(TRUE){
    #ใช้สำหรับ แสดงผล output ให้เป็นปัจจุบัน ใน colab, datalore จะมีปัญหาการแสดงผล console ตอนที่ใช้ Loop กับ readline แต่ rstudio จะไม่เจอปัญหานี้
    flush.console()
    order <- readline("What your order (id) or type (q) to finished: ")
    
    # finished orders + promotion if u buy [>=1000 bath]
    if(order == "q"){
      if (total >= 1000){
        total = total - 100}
      
      print(paste("total = ",total, "USD. Would you like to pay by cash / credit card"))
      
      break
    }
    
    # assign orders
    else{
      quantity <- as.numeric(readline("How many : "))
      
      # ดึงตำแหน่งแบบ row, column จะได้เมนูกับราคามา และนำไปคูณกับ จำนวนที่เราป้อน
      print(paste(menu[[order,"name"]], "price:",menu[[order,"price"]]*quantity))
      total <- total + (menu[[order,"price"]]*quantity)
      print(paste("total price:",total))
    }
  }
  
}