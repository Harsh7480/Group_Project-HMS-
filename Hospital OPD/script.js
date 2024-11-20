    // Team card slider
    document.addEventListener("DOMContentLoaded", function() {
        const carousel = document.querySelector(".carousel");
        const arrowBtns = document.querySelectorAll(".wrapper i");
        const wrapper = document.querySelector(".wrapper");

        const firstCard = carousel.querySelector(".card");
        const firstCardWidth = firstCard.offsetWidth;

        let isDragging = false,
            startX,
            startScrollLeft,
            timeoutId;

        const dragStart = (e) => { 
            isDragging = true;
            carousel.classList.add("dragging");
            startX = e.pageX;
            startScrollLeft = carousel.scrollLeft;
        };

        const dragging = (e) => {
            if (!isDragging) return;
        
            // Calculate the new scroll position
            const newScrollLeft = startScrollLeft - (e.pageX - startX);
        
            // Check if the new scroll position exceeds 
            // the carousel boundaries
            if (newScrollLeft <= 0 || newScrollLeft >= 
                carousel.scrollWidth - carousel.offsetWidth) {
                
                // If so, prevent further dragging
                isDragging = false;
                return;
            }
        
            // Otherwise, update the scroll position of the carousel
            carousel.scrollLeft = newScrollLeft;
        };

        const dragStop = () => {
            isDragging = false; 
            carousel.classList.remove("dragging");
        };


        const autoPlay = () => {
        
            // Return if window is smaller than 800
            if (window.innerWidth < 800) return; 
            
            // Calculate the total width of all cards
            const totalCardWidth = carousel.scrollWidth;
            
            // Calculate the maximum scroll position
            const maxScrollLeft = totalCardWidth - carousel.offsetWidth;
            
            // If the carousel is at the end, stop autoplay
            if (carousel.scrollLeft >= maxScrollLeft) return;
            
            // Autoplay the carousel after every 2500ms
            timeoutId = setTimeout(() => 
                carousel.scrollLeft += firstCardWidth, 2500);
        };

        carousel.addEventListener("mousedown", dragStart);
        carousel.addEventListener("mousemove", dragging);
        document.addEventListener("mouseup", dragStop);
        wrapper.addEventListener("mouseenter", () => 
            clearTimeout(timeoutId));
        wrapper.addEventListener("mouseleave", autoPlay);

        // Add event listeners for the arrow buttons to 
        // scroll the carousel left and right
        arrowBtns.forEach(btn => {
            btn.addEventListener("click", () => {
                // const maxScrollLeft = carousel.scrollWidth - carousel.offsetWidth;
                // if(carousel.scrollLeft >= maxScrollLeft){
                //     btn.id === "right" ? carousel.scrollLeft = 0: null;
                //     carousel.scrollLeft += -firstCardWidth;
                //     return;
                // }
                carousel.scrollLeft += btn.id === "left" ? 
                    -firstCardWidth : firstCardWidth;
                
            });
        });
});


// var tracker = 0;
// setInterval(()=>{
//     const img = ["assets/beds.jpg", "assets/bg1.jpg"];
//     document.querySelector("#header").style.backgroundImage = `url( assets/beds.jpg );`;
// }, 3000);


// Login Page

let signUpBtn = document.querySelector('.signupbtn');
        let signInBtn = document.querySelector('.signinbtn');
        let nameField = document.querySelector('.namefield');
        let title = document.querySelector('.title');
        let underline = document.querySelector('.underline');
        let text = document.querySelector('.text');


        signInBtn.addEventListener('click',()=>{
            nameField.style.maxHeight = '0';
            title.innerHTML = 'Log In';
            text.innerHTML = 'Forgot Password';
            signUpBtn.classList.add('disable');
            signInBtn.classList.remove('disable');
        });
        signUpBtn.addEventListener('click',()=>{
            nameField.style.maxHeight = '40px';
            title.innerHTML = 'Sign Up';
            text.innerHTML = 'Password Suggestions';
            signUpBtn.classList.remove('disable');
            signInBtn.classList.add('disable');
            underline.style.transform = 'translateX(0)'
        });

