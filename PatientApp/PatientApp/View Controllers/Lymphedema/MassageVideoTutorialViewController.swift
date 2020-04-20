//
//  MassageVideoTutorialViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/17/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit

class MassageVideoTutorialViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
        
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
            var slides:[Slide] = [];
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
             
                
                slides = createSlides()
                setupSlideScrollView(slides: slides)
                
                pageControl.numberOfPages = slides.count
                pageControl.currentPage = 0
                view.bringSubviewToFront(pageControl)
                
                view.bringSubviewToFront(titleLabel)
            }

            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }

            
            func createSlides() -> [Slide] {
                
                
                let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                slide1.webView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/KsJUbY0c324")!))
                slide1.labelTitle.text = "Arm Lymphatic Drainage"
                slide1.labelDesc.text = "Your lymphatic system helps eliminate your body’s waste. A healthy, active lymphatic system uses the natural movements of smooth muscle tissue to do this. If you’ve ever had a surgery on or involving your lymph nodes, your doctor may have suggested lymphatic drainage massage. Above is a video tutorial providing instruction on how to do manual lymphatic drainage in the arms."
                
                let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                slide2.webView.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/87NdIiSnOjA")!))
                slide2.labelTitle.text = "Leg Lymphatic Drainage"
                slide2.labelDesc.text = "Your lymphatic system helps eliminate your body’s waste. A healthy, active lymphatic system uses the natural movements of smooth muscle tissue to do this. If you’ve ever had a surgery on or involving your lymph nodes, your doctor may have suggested lymphatic drainage massage. Above is a video tutorial providing instruction on how to do manual lymphatic drainage in the legs."
                
        
                
                return [slide1, slide2]
            }
            
            
            func setupSlideScrollView(slides : [Slide]) {
                scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
                scrollView.isPagingEnabled = true
                
                for i in 0 ..< slides.count {
                    slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
                    scrollView.addSubview(slides[i])
                }
            }
            
            
            /*
             * default function called when view is scolled. In order to enable callback
             * when scrollview is scrolled, the below code needs to be called:
             * slideScrollView.delegate = self or
             */
            func scrollViewDidScroll(_ scrollView: UIScrollView) {

                // establish page control indexing
                let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
                pageControl.currentPage = Int(pageIndex)
                
                // horizontal
                let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
                let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
                let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
                
                //stop scrolling in the vertical direction
                    if scrollView.contentOffset.y != 0 {
                        scrollView.contentOffset.y = 0
                    }
                
                // vertical
                //let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
                //let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
                //let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
                
                
                /*
                 * below code changes the background color of view on paging the scrollview
                 */
                self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
                
            
                /*
                 * below code scales the webView on paging the scrollview
                 */
                /*
                let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
                
            
                if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
                    
                    slides[0].webView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
                    slides[1].webView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
                    
                }
                */
            }
            
            
            
            
            func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
                if(pageControl.currentPage == 0) {
                    //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
                    //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
                    //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
                    
                    let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 200/255, toGreen: 200/255, toBlue: 200/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                    pageControl.pageIndicatorTintColor = pageUnselectedColor
                
                    
                    //let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                    //slides[pageControl.currentPage].backgroundColor = bgColor
                    
                    let pageSelectedColor: UIColor = fade(fromRed: 100/255, fromGreen: 0/255, fromBlue: 100/255, fromAlpha: 1, toRed: 100/255, toGreen: 0/255, toBlue: 100/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                    pageControl.currentPageIndicatorTintColor = pageSelectedColor
                }
            }
            
            
            func fade(fromRed: CGFloat,
                      fromGreen: CGFloat,
                      fromBlue: CGFloat,
                      fromAlpha: CGFloat,
                      toRed: CGFloat,
                      toGreen: CGFloat,
                      toBlue: CGFloat,
                      toAlpha: CGFloat,
                      withPercentage percentage: CGFloat) -> UIColor {
                
                let red: CGFloat = (toRed - fromRed) * percentage + fromRed
                let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
                let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
                let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
                
                // return the fade colour
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        }
