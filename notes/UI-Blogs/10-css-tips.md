[source](https://dev.to/aviligonda/10-common-mistakes-in-css-532j)
**1.Use Shorthand :** CSS shorthand is a group of CSS properties that allow values of multiple properties to be set simultaneously. These values are separated by spaces. For example, the border property is shorthand for the margin-top, margin-right, margin-left and margin-bottom properties.  
//Not Using Shorthand  
```css
.example{  
margin-top:10px;  
margin-bottom:19px;  
margin-left:10px;  
margin-right:19px;  
}  
```
//Better way  
```css
.example{  
margin:10px 19px;  
}  
```
**2.Responsive design :** If your website become responsive, avoid use the px instead use the percentage. Below example container class 1000px is not correct why because, screen device vary from different screen so that time it will take fixed 1000px only. better to use 100%.

//Not correct way  
```css
.container{  
width:1000px;  
}  
```
//correct way for responsive  
```css
.container{  
width:100%;  
} 
``` 
**3.Repeating the Same Code :** If you want properties to other class don’t write like new code. use classes with separated by comma(,).

One more point is ,if required extra property to element use the other class and for that class write css. it will reduce duplicate code.

//Not correct  
```css
.box1{  
width:50%;  
margin:20px;  
}  
.box2{  
width:50%;  
margin:20px;  
} 
``` 
//Correct  
```css
.box1,.box2{  
width:50%;  
margin:20px;  
}  
```
**4.No font fallback :** What is font fallback font?

A fallback font is a font face that is used when the primary font face is not loaded yet, or is missing glyphs necessary to render page content. For example, the CSS below indicates that the Helvetica font family should be used as the font fallback for “Arial”

//Not good  
```css
body{  
font-family:Helvetica;  
}  
```
//Good  
```css
body{  
font-family:Helvetica, Arial,Sans-serif;  
}
```  
Some browser may not support some CSS font families, so we can use like fallback, it will support next font families instead of default one.

**5.Using Color Names :**

Better way use hex color codes instead of Color names

//Not good  
```css
.example{  
color:green;  
} 
``` 
//Good  
```css
.example{  
color:#00ff00;  
}  
```
**6.Complicating Selectors :**

When you can use direct class for a particular element, you should not complicate by nesting with different selectors.

//It is good some times, but better to don't go eith complicate  
```css
header .navigation ul.nav-links{  
list-style-type:none;  
}  
```
you can just use class for simplicity & It will be also easy to read & Understand

//Better  
```css
.nav-links{  
list-style-type:none;  
} 
``` 
**7.Z-Index mistakes :**

Many developers use a really high z-index value to put an element in front.

And it becomes difficult when you want to put another element in front of others. the Z-Index value starts increasing much higher.

```css
.modal-container{  
z-index:545;  
}  
.modal{  
z-index:5345345;  
}  
```
The solution to use moderate values, so that it doesn’t become difficult for long run.

```css
.modal-container{  
z-index:1;  
}  
.modal{  
z-index:2;  
} 
``` 
**8. Inconsistency names :** My opinion is based preparing web pages content, CSS class or id names should be like that only it’s better.

Why I am telling means , If we use like other developers understand immediately, no need search for that.

```css
.header{  
font-size:2rem;  
}  
```
**9.When to use class and Id :**

When we access value from element better to use “id”, when prepare designs we classes, id’s are unique, classes we can use multiple times.

i)Id : id is unique so access data easy, of use class we need add index to that element like [0].

  
let name = document.getElementById('name').value;  
console.log(name);  
ii) classes : classes can re-use, so better follow this way.

Paragrah

```css
.classData{  
margin:20px  
}  
```
**10. Ignoring Cross-Browser Compatibility:** Different browsers may interpret CSS rules differently, leading to inconsistent visual appearance across platforms. Test your CSS code on multiple browsers and consider using CSS prefixes or vendor-specific prefixes for compatibility with older browser versions.

Before write new CSS properties in code check, which browser support which CSS properties by using the [https://caniuse.com/](https://caniuse.com/)

