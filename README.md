# SafeSpace


This is a project created by Neal Soni, Dylan Gleicher, Jainil Sutaria, and William Peng for the 2018 Yale Hackathon.

Safe Spaces is an open source project that allows individuals with disabilities to identify whether or not a location is accessible based on whether or not there’s 
- Safety ramps
- Door Widths
- Elevators/Lifts
- Vision Aids
- And many more characteristics

If the location is not accessible, Safe Spaces automatically recommends nearby locations of the same variety that have a high accessibility rating. 

To gain full access to all the features, we recommend you download our app here, run in xcode 10.1 or higher. 

The google App Engine and Cloud SQL server code can be found at: https://github.com/dgleiche/SafeSpacesBackend


The Database main table is as follow:

##Disabilities Database:
- Motion Impairment
- Wheelchair Bound
- Autism Spectrum Disorder
- Sight Impairment 
- Hearing Impairment

##Location Database:
- googlePlaceID
- Location Name
- Address 
- City 
- State
- Zip Code
- Lat, Lon
- Type of location (Food, Industry, education, ...)
- Accessibility information:
    - Score: %
    - Generally accessible: Bool 	(required)
    - Ramps: Bool			(required)
    - Smooth: Bool			(required)
    - elevators/lifts: Bool		(required)
    - Automatic doors: Bool 	(required)
    - Brail: Bool			(optional)
    - Parking: Bool			(required)
    - Bathrooms: Bool		(required)
    - SightImparedSigns: Bool	(required)
    - Brail: Bool			(optional)
    - SoundMeasure: Decibels (float)  (optional)
    - Sound: Bool			(required)
    - Other:
        - Description (string)	(optional)
        - Photos	([string])	(optional)
        - Width of door frames. [Array of floats]
        - Height of tables	[Array of floats]

